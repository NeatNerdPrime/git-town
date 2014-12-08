Feature: Git Sync: syncing a feature branch with open changes


  Scenario: without a remote branch
    Given I am on a local feature branch
    And the following commits exist in my repository
      | BRANCH  | LOCATION | MESSAGE              | FILE NAME          |
      | main    | local    | local main commit    | local_main_file    |
      | main    | remote   | remote main commit   | remote_main_file   |
      | feature | local    | local feature commit | local_feature_file |
    And I have an uncommitted file with name: "uncommitted" and content: "stuff"
    When I run `git sync`
    Then I am still on the "feature" branch
    And I still have an uncommitted file with name: "uncommitted" and content: "stuff"
    And all branches are now synchronized
    And I have the following commits
      | BRANCH  | LOCATION         | MESSAGE                          | FILES              |
      | main    | local and remote | local main commit                | local_main_file    |
      | main    | local and remote | remote main commit               | remote_main_file   |
      | feature | local and remote | Merge branch 'main' into feature |                    |
      | feature | local and remote | local main commit                | local_main_file    |
      | feature | local and remote | remote main commit               | remote_main_file   |
      | feature | local and remote | local feature commit             | local_feature_file |
    And now I have the following committed files
      | BRANCH  | FILES                                                 |
      | main    | local_main_file, remote_main_file                     |
      | feature | local_feature_file, local_main_file, remote_main_file |


  Scenario: with a remote branch
    Given I am on a feature branch
    And the following commits exist in my repository
      | BRANCH  | LOCATION | MESSAGE               | FILE NAME           |
      | main    | local    | local main commit     | local_main_file     |
      | main    | remote   | remote main commit    | remote_main_file    |
      | feature | local    | local feature commit  | local_feature_file  |
      | feature | remote   | remote feature commit | remote_feature_file |
    And I have an uncommitted file with name: "uncommitted" and content: "stuff"
    When I run `git sync`
    Then I am still on the "feature" branch
    And I still have an uncommitted file with name: "uncommitted" and content: "stuff"
    And I have the following commits
      | BRANCH  | LOCATION         | MESSAGE                                                    | FILES               |
      | main    | local and remote | local main commit                                          | local_main_file     |
      | main    | local and remote | remote main commit                                         | remote_main_file    |
      | feature | local and remote | Merge branch 'main' into feature                           |                     |
      | feature | local and remote | Merge remote-tracking branch 'origin/feature' into feature |                     |
      | feature | local and remote | local main commit                                          | local_main_file     |
      | feature | local and remote | remote main commit                                         | remote_main_file    |
      | feature | local and remote | local feature commit                                       | local_feature_file  |
      | feature | local and remote | remote feature commit                                      | remote_feature_file |
    And now I have the following committed files
      | BRANCH  | FILES               |
      | main    | local_main_file, remote_main_file |
      | feature | local_feature_file, remote_feature_file, local_main_file, remote_main_file |