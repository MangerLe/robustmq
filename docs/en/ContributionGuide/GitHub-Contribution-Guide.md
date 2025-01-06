# GitHub Contribution Guide

## 1. Creating an ISSUE

The main types of ISSUES include: feat, bug, test, refactor, chore, style, docs, perf, build, ci. The corresponding explanations are as follows:
- feat: New feature
- bug: Bug issue
- test: Additional test cases
- refactor: Code refactoring that is neither a new feature nor a bug fix
- docs: Changes and additions to documentation, including code comments
- perf: Code involving performance optimization, which requires proof of optimization
- build: Changes to the build system or external dependencies
- ci: Changes to continuous integration configuration, including modifications to configuration files and scripts
- style: Code style changes, used for submission formatting, punctuation, etc., that do not affect the code
- chore: Mixed types of work, possibly involving multiple other types of changes

### Users and Contributors Creating ISSUES

For users, if there are new feature requirements or bug fixes, they can submit an Issue by selecting `BugReport` and `FeatureRequest`.

![image](../../images/GithubContributionGuide-1.png)

For contributors, if there are new feature requirements or bug fixes for a `Pull Request`, they should also create corresponding `BugReport` and `FeatureRequest` ISSUES before submitting the `Pull Request`. For other types of `Pull Request` submissions, use `Enhancement` to create an Issue according to the corresponding category before submitting the `Pull Request`.

![image](../../images/GithubContributionGuide-2.png)

### Committer Creating ISSUES

Creating various types of Issues is the same as for users, but since this involves proactive planning and task development, there are two scenarios. For small tasks, directly use `BugReport`, `Enhancement`, `FeatureRequest` to associate with the `Pull Request`. For larger planned tasks that need to be broken down, use `Umbrella` to associate with the corresponding Issue and plan subtasks below it, as shown below:

todo Add images on how to use umbrella to create subtasks

For each subtask, create the corresponding subtask using `Subtask` and describe the specific content that needs to be completed for that subtask.

For the title of `Umbrella`, it is temporarily divided into two categories, RBIP-* and MINOR.

RBIP-*: Indicates the addition of features and characteristics, such as RBIP-09, RBIP-10, with the sequence number increasing.
![image](../../images/GithubContributionGuide-3.png)

MINOR: Indicates fixing or adding small features. It can start with MINOR, followed by the title.
![image](../../images/doc-image10.png)

## 2. Creating a Pull Request

If the PR is associated with an ISSUE, it must include the following in the PR content:

```
close #issue_number
```

`close` is a fixed prefix, `#` is also a fixed prefix, and `issue_number` represents the ISSUE number associated with the PR. For example:

![image](../../images/doc-image11.png)

#297, #292 are the corresponding ISSUE numbers.

For example, if you need to submit a PR to resolve ISSUE #297, the PR content should include:

```
close #297
```

When this PR is MERGED, the ISSUE will be automatically closed. After the PR is merged, the PR and ISSUE will look like this:

PR:
![image](../../images/doc-image12.png)

ISSUE:
![image](../../images/doc-image13.png)

For more details, you can refer to the [PR submission example](./Pull-Request-Example.md).

## 3. Reasons for PR Submission Failure

#### License Error

License checker / license-header-check (pull_request) failed. Some files are missing a License, which needs to be added. It is best to run the check command before each submission.

```
cargo install hawkeye

# Execute in the current project to check which files are missing a License
hawkeye check

# Automatically add a License to each code file
hawkeye format
```

#### Title Format Error

PR Title Checker / check (pull_request_target) failed due to incorrect PR title format.

```
Prefix: Title
Prefix options include: feat|fix|test|refactor|chore|style|docs|perf|build|ci|revert

feat: New feature
For example: feat: Compatible with Rocksdb

fix: Bug fix
docs: Documentation change
style: Code style change (does not affect code logic), used for submissions that only involve formatting, punctuation, whitespace, etc., that do not affect code execution.
refactor: Code refactoring (code changes that are neither new features nor bug fixes)
perf: Performance optimization
test: Adding or modifying tests
chore: Miscellaneous (changes to the build process or auxiliary tools)
build: Changes to the build system or external dependencies
ci: Changes to continuous integration configuration, including modifications to configuration files and scripts.
revert: Revert
```