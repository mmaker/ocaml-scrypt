#define CAML_NAME_SPACE

#include <string.h>
#include <caml/mlvalues.h>
#include <caml/memory.h>
#include <caml/alloc.h>
#include <caml/callback.h>
#include <caml/fail.h>
#include <libscrypt.h>

#define SCRYPT_MALLOC_ERROR 6

#define check_mem(A) if(!(A)) { goto error; }
#define check_err(A) if(A) { goto error; }

typedef struct scrypt_args {
  uint8_t *passwd;
  size_t  passwdlen;
  uint8_t *salt;
  size_t saltlen;
  uint64_t N;
  uint64_t r;
  uint64_t p;
} scrypt_args_t;

scrypt_args_t scrypt_convert_args(value passwd, value salt, value n, value r, value p) {
  scrypt_args_t args = {
    .passwd = &Byte_u(passwd, 0),
    .passwdlen = caml_string_length(passwd),
    .salt = &Byte_u(salt, 0),
    .saltlen = caml_string_length(salt),
    .N = Unsigned_long_val(n),
    .r = Unsigned_long_val(r),
    .p = Unsigned_long_val(p)
  };
  return args;
}


void scrypt_raise_scrypt_error(int err_code) {
	CAMLparam0();
	CAMLlocal1(code_val);

	static value *exn = NULL;
	if( !exn ) {
          exn = caml_named_value("Scrypt_error");
	}

	code_val = Val_int(err_code);
	caml_raise_with_arg(*exn, code_val);

	CAMLreturn0;
}

CAMLprim value _scrypt(value passwd, value salt, value N, value r, value p) {

  CAMLparam5(passwd, salt, N, r, p);
  CAMLlocal1(cyphertext);

  int err = SCRYPT_MALLOC_ERROR;
  uint8_t *buf = NULL;
  scrypt_args_t args = scrypt_convert_args(passwd, salt, N, r, p);

  const size_t buflen = 256 / 8;
  cyphertext = caml_alloc_string(buflen);
  buf = &Byte_u(cyphertext, 0);

  err = libscrypt_scrypt(
                         args.passwd, args.passwdlen,
                         args.salt, args.saltlen,
                         args.N, args.r, args.p,
                         buf, buflen);
  check_err(err);

  CAMLreturn(cyphertext);

 error:
  scrypt_raise_scrypt_error(err);
  CAMLreturn(cyphertext);
}


CAMLprim value _salt_gen(value unit) {
  CAMLparam1(unit);
  CAMLlocal1(salt);

  const size_t saltlen = 256 / 8;
  salt = caml_alloc_string(saltlen);
  uint8_t *saltbuf = &Byte_u(salt, 0);
  libscrypt_salt_gen(saltbuf, saltlen);

  CAMLreturn(salt);
}
