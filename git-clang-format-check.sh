#!/bin/bash

# Print that the pre-commit hook is used.
echo "Pre-Commit Hook Running: Clang-Format Check"

# Change into the git root directory.
cd `git rev-parse --show-toplevel`

# Get changed and staged files of current commit.
staged_files=`git diff --name-only --staged`
# Assume everything is correctly formatted.
is_not_formatted=0
# File Name used for the temporary file.
tmp_file=".pre-commit.git-clang-format-check.tmp"

# Run loop over all staged files.
for file in $staged_files; do
  # Check for typical C/C++ extensions.
  if [[ $file =~ .*\.(h|c|cc|hpp|cpp|ipp|tpp|hxx|cxx|ixx|txx)(.in)?$ ]]; then
    # Run clang-format with currently used style file
    # and save its output to a temporary file.
    clang-format -style=file $file > $tmp_file
    # Diff the temporary file against the original file.
    diff_str=`diff $file $tmp_file`
    # If the diff string is not empty then
    # the file has not been correctly formatted.
    if test -n "$diff_str"; then
      # For an appropriate error message,
      # add unformatted files to error vector.
      files=$files" "$file
      # Make sure pre-commit hook exits with non-zero state.
      is_not_formatted=1
    fi
  fi
done

# Make sure to remove temporary file if it has been created.
rm -f .pre-commit.clang-format-check.tmp

# Show error message if unformatted files have been found.
if test $is_not_formatted -eq 1; then
  echo Error: Failed while running pre-commit hook.
  echo The following files are not correctly formatted.
  echo ""
  # List all files to make fixing faster.
  for file in $files; do
    echo "  "$file
  done
  echo ""
  echo Run the following clang-format command to fix this.
  echo ""
  echo "  clang-format -style=file -i <file>"
  echo ""
fi

# Return the error code.
exit $is_not_formatted