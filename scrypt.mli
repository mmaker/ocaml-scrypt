(** Strong, password based encryption.

    No wheels invented. This module is a high level interface to the {{: https://www.tarsnap.com/scrypt.html } official scrypt distribution}.

    Scrypt is designed to make it costly to perform large scale custom hardware attacks by requiring large amounts of memory. {{: htps://en.wikipedia.org/wiki/Scrypt } (Wikipedia) }
*)

(** [Scrypt_error code] indicates an error during a call to the underlying C implementation of scrypt.

    [code] is the exact return code reported by the underlying implementation and is defined as one of the following:
    - [0] success
    - [1] getrlimit or sysctl(hw.usermem) failed
    - [2] clock_getres or clock_gettime failed
    - [3] error computing derived key
    - [4] could not read salt from /dev/urandom
    - [6] malloc failed
    - [7] data is not a valid scrypt-encrypted block
    - [8] unrecognized scrypt format
    - [9] decrypting file would take too much memory
    - [10] decrypting file would take too long
    - [11] password is incorrect
*)
exception Scrypt_error of int

(** [encrypt data passwd] encrypts [data] using [passwd] and returns [Some string] of the cyphertext or [None] if there was an error.

    The default values of [maxmem=0], [maxmemfrac=0.125], and [maxtime=5.0] are chosen to match the the reference scrypt implementation.

    See {!scrypt_params}.
*)
val scrypt : ?n:int -> ?r:int -> ?p:int -> string -> string -> (string, unit) result

(** Same as {!encrypt} except raise {!Scrypt_error} in case of an error. *)
val salt_gen : unit -> string
