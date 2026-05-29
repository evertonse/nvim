;; extends
(declaration
  [
    (type_identifier)
    (identifier)
  ] @keyword.storage
  (#any-of? @keyword.storage
    "overload"
    "internal"
    "require"
    "private"
    "thread_local")
  (#set! priority 110))
