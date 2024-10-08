mod common;

#[cfg(test)]
mod tests {
    use std::time::Duration;

    use bytes::Bytes;
    use futures::{SinkExt, StreamExt};
    use protocol::mqtt::{
        common::{Connect, LastWill, Login, MQTTPacket},
        mqttv4::codec::Mqtt4Codec,
    };
    use tokio::{
        net::TcpStream,
        time::{sleep, Instant},
    };
    use tokio_util::codec::Framed;

    #[tokio::test]
    async fn mqtt4_keep_alive_test() {
        let socket = TcpStream::connect("127.0.0.1:1883").await.unwrap();
        let mut stream: Framed<TcpStream, Mqtt4Codec> = Framed::new(socket, Mqtt4Codec::new());

        // send connect package
        let packet = build_mqtt4_pg_connect();
        let _ = stream.send(packet).await;
        let now = Instant::now();
        loop {
            if let Some(data) = stream.next().await {
                match data {
                    Ok(da) => {
                        println!("success:{:?}", da);
                    }
                    Err(e) => {
                        println!("error:{}", e.to_string());
                    }
                }
            }


            if now.elapsed().as_secs() > 20 {
                break;
            }
            sleep(Duration::from_secs(1)).await;
        }
    }

    /// Build the connect content package for the mqtt4 protocol
    fn build_mqtt4_pg_connect() -> MQTTPacket {
        let client_id = String::from("test_client_id");
        let login = Some(Login {
            username: "admin".to_string(),
            password: "pwd123".to_string(),
        });
        let lastwill = Some(LastWill {
            topic: Bytes::from("topic1"),
            message: Bytes::from("connection content"),
            qos: protocol::mqtt::common::QoS::AtLeastOnce,
            retain: true,
        });

        let connect: Connect = Connect {
            keep_alive: 10, // 30 seconds
            client_id: client_id,
            clean_session: true,
        };
        return MQTTPacket::Connect(4, connect, None, lastwill, None, login);
    }
}
