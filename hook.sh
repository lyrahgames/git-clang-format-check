#!/bin/bash

# Print that the pre-commit hook is used.
echo "Pre-Commit Hook Running: Clang-Format Check"
echo ""

# Change into the git root directory.
cd `git rev-parse --show-toplevel`

# Set up the error message header.
error_header='\033[0;31mERROR: Failed while running pre-commit hook.\033[0m'

# Check if clang-format can be called.
if ! clang-format --style=llvm --dump-config >/dev/null; then
  echo ""
  echo -e $error_header
  echo "The command 'clang-format' cannot be called correctly."
  echo ""
  exit -1;
fi

# Check if style is given by .clang-format file.
if [ ! -f ".clang-format" ]; then
  echo -e $error_header
  echo "Failed to find '.clang-format' file in the repository root directory."
  exit -1
fi

# Check if Clang-Format style file is valid.
if ! clang-format --style=file --dump-config >/dev/null; then
  echo ""
  echo -e $error_header
  echo "The style file '.clang-format' is invalid."
  echo "Run the following command to check for yourself."
  echo ""
  echo "  clang-format --style=file --dump-config"
  echo ""
  exit -1
fi

# Get changed and staged files of current commit.
staged_files=`git diff --name-only --staged`
# Assume everything is correctly formatted.
is_not_formatted=0
# File Name used for the temporary file.
tmp_file_suffix=".git-clang-format-check.tmp"

# Run loop over all staged files.
for file in $staged_files; do
  # Check for typical C/C++ extensions.
  if [[ $file =~ .*\.(h|c|cc|hpp|cpp|ipp|tpp|hxx|cxx|ixx|txx)(.in)?$ ]]; then
    # Run clang-format with currently used style file
    # and save its output to a temporary file.
    tmp_file=$file$tmp_file_suffix
    clang-format -style=file $file > $tmp_file
    # Diff the temporary file against the original file.
    diff_str=`diff $file $tmp_file`
    # Remove temporary file.
    rm -f $tmp_file
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

# Show error message if unformatted files have been found.
if test $is_not_formatted -eq 1; then
  echo -e $error_header
  echo "The following files are not correctly formatted."
  echo ""
  # List all files to make fixing faster.
  for file in $files; do
    echo "  "$file
  done
  echo ""
  echo "Run the following command for these files to fix this."
  echo ""
  echo "  clang-format -style=file -i <file>"
  echo ""
fi

# Return the error code.
exit $is_not_formatted