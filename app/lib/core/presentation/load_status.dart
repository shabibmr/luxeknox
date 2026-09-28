/// Server-load lifecycle for a single state class (ADR-0006 §5).
///
/// `loading` and `failure` must not clear data already on screen.
enum LoadStatus { initial, loading, success, failure }
