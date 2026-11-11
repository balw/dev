# Global Instructions

## Verification

- Delegate full test suites, builds, lint runs and type checks to the `verify` subagent. Give it the repository path, a summary of the changes, and the scope to check.
- Run quick, narrow checks yourself (a single test file or one command).
- After fixing issues `verify` found, have `verify` run the recheck.
