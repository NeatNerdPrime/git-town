package cmd

import (
	"fmt"
	"strings"

	"github.com/Originate/git-town/lib/git"
	"github.com/spf13/cobra"
)

var branchToAdd string
var branchToRemove string

var perennialBranchesCommand = &cobra.Command{
	Use:   "perennial-branches",
	Short: "Displays or updates your perennial branches",
	Run: func(cmd *cobra.Command, args []string) {
		if branchToAdd != "" {
			addPerennialBranch(branchToAdd)
		} else if branchToRemove != "" {
			removePerennialBranch(branchToRemove)
		} else {
			printPerennialBranches()
		}
	},
	PreRunE: func(cmd *cobra.Command, args []string) error {
		return validateMaxArgs(args, 0)
	},
}

func addPerennialBranch(branchName string) {
	git.EnsureHasBranch(branchToAdd)
	git.EnsureIsNotMainBranch(branchToAdd, fmt.Sprintf("'%s' is already set as the main branch", branchToAdd))
	git.EnsureIsNotPerennialBranch(branchToAdd, fmt.Sprintf("'%s' is already a perennial branch", branchToAdd))
	git.AddToPerennialBranches(branchToAdd)
}

func printPerennialBranches() {
	output := strings.Join(git.GetPerennialBranches(), "\n")
	if output == "" {
		output = "[none]"
	}
	fmt.Println(output)
}

func removePerennialBranch(branchName string) {
	git.EnsureIsPerennialBranch(branchToRemove, fmt.Sprintf("'%s' is not a perennial branch", branchToRemove))
	git.RemoveFromPerennialBranches(branchToRemove)
}

func init() {
	perennialBranchesCommand.Flags().StringVar(&branchToAdd, "add", "", "Specify a branch to add")
	perennialBranchesCommand.Flags().StringVar(&branchToRemove, "remove", "", "Specify a branch to remove")
	RootCmd.AddCommand(perennialBranchesCommand)
}
