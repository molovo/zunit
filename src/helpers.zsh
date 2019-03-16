################################
# Helpers for use within tests #
################################

###
# Colorise and style a string
###
function color() {
  local color=$1 style=$2 b=0

  shift

  case $style in
    bold|b)           b=1; shift ;;
    italic|i)         b=2; shift ;;
    underline|u)      b=4; shift ;;
    inverse|in)       b=7; shift ;;
    strikethrough|s)  b=9; shift ;;
  esac

  case $color in
    black|b)    echo "\033[${b};30m${@}\033[0;m" ;;
    red|r)      echo "\033[${b};31m${@}\033[0;m" ;;
    green|g)    echo "\033[${b};32m${@}\033[0;m" ;;
    yellow|y)   echo "\033[${b};33m${@}\033[0;m" ;;
    blue|bl)    echo "\033[${b};34m${@}\033[0;m" ;;
    magenta|m)  echo "\033[${b};35m${@}\033[0;m" ;;
    cyan|c)     echo "\033[${b};36m${@}\033[0;m" ;;
    white|w)    echo "\033[${b};37m${@}\033[0;m" ;;
    *)          echo "\033[${b};38;5;$(( ${color} ))m${@}\033[0;m" ;;
  esac
}

###
# Find a file, and load it into the environment
###
function load() {
  local name="$1"
  local filename

  # If filepath is absolute, then use it as is
  if [[ "${name:0:1}" = "/" ]]; then
    filename="${name}"
  # If it's relative, prepend the test directory
  else
    filename="$testdir/${name}"
  fi

  # Check if the file exists
  if [[ -f "$filename" ]]; then
    # Source the file and exit if it's found
    source "$filename"
    return 0
  fi

  # Perform the check again, adding the .zsh extension
  if [[ -f "$filename.zsh" ]]; then
    # Source the file and exit if it's found
    source "$filename.zsh"
    return 0
  fi

  # We couldn't find the file, so output an error message to the user
  # and fail the test
  echo "File $filename does not exist" >&2
  exit 1
}

###
# Run an external command and capture its output and exit status
###
function run() {
  # Within tests, the shell is set to exit immediately when errors
  # occur. Since we want to capture the exit code of the command
  # we're running, we stop the shell from exiting on error temporarily
  unsetopt ERR_EXIT

  # Preserve current $IFS
  local oldIFS=$IFS name
  local -a cmd

  # Store each word of the command in an array, and grab the first
  # argument which is the command name
  cmd=("${@[@]}")
  name="${cmd[1]}"

  # If the command is not an existing command or file,
  # then prepend the test directory to the path
  type $name > /dev/null
  if [[ $? -ne 0 && ! -f $name && -f "$testdir/${name}" ]]; then
    cmd[1]="$testdir/${name}"
  fi

  # Store full output in a variable
  output=$("${cmd[@]}" 2>&1)

  # Get the process exit state
  state="$?"

  # Store individual lines of output in an array
  IFS=$'\n'
  lines=("${(@f)output}")

  # Restore $IFS
  IFS=$oldIFS

  # Print the command output if --verbose is specified
  if [[ -n $verbose && -n $output ]]; then
    echo $output
  fi

  # Restore the exit on error state
  setopt ERR_EXIT
}

function _assert() {
  local value=$1 assertion=$2
  local -a comparisons

  # Preserve current $IFS
  local oldIFS=$IFS
  IFS=$'\n'

  # Store all comparison values in an array
  comparisons=(${(@)@:3})

  # If no assertion is passed, then use the first value, as it
  # could be that the value is simply empty
  if [[ -z $assertion ]]; then
    assertion=$value
    value=""
  fi

  # Check that the requested assertion method exists
  if (( ! $+functions[_zunit_assert_${assertion}] )); then
    echo "$(color red "Assertion $assertion does not exist")"
    exit 127
  fi

  # Increment the assertion count
  _zunit_assertion_count=$(( _zunit_assertion_count + 1 ))

  # Run the assertion
  "_zunit_assert_${assertion}" "$value" ${(@f)comparisons[@]}

  local state=$?

  # Reset $IFS
   IFS=$oldIFS

   return $state
}


###
# Redirect the assertion shorthand to the correct function
###
function assert() {
  _assert "$@"
  local state=$?

  if [[ $state -ne 0 ]]; then
    exit $state
  fi
}


###
# Redirect the assertion shorthand to the correct function
###
function assert_not() {
  _assert "$@"
  local state=$?

  if [[ $state -eq 0 ]]; then
    exit $state
  fi
}


###
# Mark the current test as passed
###
function pass() {
  # Exit code 0 will end the test, and mark is as passed. The reason for
  # skipping is echoed to stdout first, so that it can be picked up by the
  # error handler
  exit 0
}

###
# Mark the current test as failed
###
function fail() {
  # Any non-zero exit code without special meaning will mark the test as failed.
  # The failure message is echoed to stdout first, so that it can be picked up
  # by the error handler
  echo "$@"
  exit 1
}

###
# Mark the current test as skipped
###
function error() {
  # Exit code 78 will end the test, and report an error. The error message
  # is echoed to stdout first, so that it can be picked up by the error handler
  echo "$@"
  exit 78
}

###
# Mark the current test as skipped
###
function skip() {
  # Exit code 48 will skip the test, so all we have to do
  # to mark the test as skipped is exit.
  # The reason for skipping is echoed to stdout first, so that
  # it can be picked up by the error handler
  echo "$@"
  exit 48
}
