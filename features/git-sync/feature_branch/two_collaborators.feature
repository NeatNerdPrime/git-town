Feature: Git Sync: collaborative feature branch syncing


  Scenario: merging work
    Given I am on a feature branch
    And my coworker Charlie works on the same feature branch
    And the following commits exist in my repository
      | LOCATION  | MESSAGE     | FILE NAME |
      | local     | my commit 1 | my_file_1 |
    And the following commits exist in Charlie's repository
      | LOCATION | MESSAGE           | FILE NAME      |
      | local    | charlies commit 1 | charlie_file_1 |
    When I run `git sync`
    Then I see the following commits
      | BRANCH  | LOCATION         | MESSAGE     | FILES     |
      | feature | local and remote | my commit 1 | my_file_1 |
    And Charlie still sees the following commits
      | BRANCH  | LOCATION | MESSAGE           | FILES          |
      | feature | local    | charlies commit 1 | charlie_file_1 |
    When Charlie runs `git sync`
    Then now Charlie sees the following commits
      | BRANCH  | LOCATION         | MESSAGE                                                    | FILES          |
      | feature | local and remote | Merge remote-tracking branch 'origin/feature' into feature |                |
      | feature | local and remote | charlies commit 1                                          | charlie_file_1 |
      | feature | local and remote | my commit 1                                                | my_file_1      |
    When I run `git sync`
    Then now I see the following commits
      | BRANCH  | LOCATION         | MESSAGE                                                    | FILES          |
      | feature | local and remote | Merge remote-tracking branch 'origin/feature' into feature |                |
      | feature | local and remote | charlies commit 1                                          | charlie_file_1 |
      | feature | local and remote | my commit 1                                                | my_file_1      |