exception Scrypt_error of int
let _ = Callback.register_exception "Scrypt_error" (Scrypt_error 0)

external _scrypt : string -> string -> int -> int -> int -> string = "_scrypt"
external _salt_gen : unit -> string = "_salt_gen"
(* Default values for optional arguments are chosen to match the scrypt command line utility. *)

let scrypt ?(n=16384) ?(r=8) ?(p=1) passwd salt =
  match _scrypt passwd salt n r p with
  | cx -> Ok cx
  | exception Scrypt_error _ -> Error ()

let salt_gen = _salt_gen
