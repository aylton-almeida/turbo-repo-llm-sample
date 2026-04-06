# Flutter Rules

## Structure

Use feature-first modules under `lib/features/<name>/data|domain|presentation`.

## Rules

- Use Riverpod codegen with `@riverpod`
- Run codegen after provider/model changes (`make gen`)
- Use Freezed for data models (`@freezed` + json_serializable)
- Use Go Router named routes only
- Prefer `ConsumerWidget` when reading providers
- Avoid `print()`
- Always include `super.key` in widget constructors
