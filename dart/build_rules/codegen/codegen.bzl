"""Create binaries that generate code, and rules that run those binaries.

The rules generated by `dart_codegen_rule` have the following arguments:

- generate_for: Optional. The Dart source files which will have associated
  generated files. If `generated_for` is not provided everying in `srcs` will be
  considered an input. One of `generate_for` or `srcs` must be provided.
- srcs: Optional. Dart source files which may be inputs to the code generation,
  or may be imported by other code but does not exist in a separate build
  target.
- forced_deps: Optional. All files from these deps will be provided as inputs to
  the codegen actions.
- generator_args: Arbitrary arguments which can be passed to the codegen binary.

Arguments to the codegen binary can be specified in 3 places:
  - At the definition of the rule
  - At the site the rules is used
  - At build time using `--define` flags, if the `dart_codegen_rule` specifies
    an `arg_prefix`.

For example:

# Rule definition
my_rule = dart_codegen_rule(
    arg_prefix=["MY"], # Allows build-time flags
    build_extensions = {".dart": [".g.dart"]},
    codegen_binary="//codegen_binary_target",
    generator_args=["--foo=definition"],
)

# Rule usage in a BUILD file
my_rule(
    name="some_target",
    srcs = glob(["lib/**/*dart"]),
    generator_args=["--foo=usage", "--bar=usage"],
)

# When building
bazel build //some_target --define=MY_CODGEN_ARGS=foo=defined,bar=defined

The overall arguments to the binary will be
    --foo=definition --foo=usage --bar=usage --foo=define --bar=defined

Since arguments are repeated rather than replaced the codegen binaries should
prefer to use a last-definition-wins strategy. This is the behavior of
package:args in Dart.

Arguments passed using --define have the following restrictions:
  - Values cannot contain commas
  - Only long-form (double dash) arguments can be used
  - Only --argument=value can be used, `argument,value` would get passed as
    --argument --value
"""

load(
    ":_codegen_binary.bzl",
    _codegen_binary = "codegen_binary",
)
load(
    ":_codegen_rule.bzl",
    _codegen_rule = "codegen_rule",
)
load(
    ":_codegen_aspect.bzl",
    _codegen_aspect = "codegen_aspect",
)

dart_codegen_binary = _codegen_binary
dart_codegen_rule = _codegen_rule
dart_codegen_aspect = _codegen_aspect
