
all:
	ocamlfind ocamlopt -o scrypt_stubs scrypt_stubs.c -ccopt -fPIC -cclib -lscrypt
	ocamlfind ocamlc -c scrypt.mli scrypt.ml
	ocamlfind ocamlc -c scrypt.mli scrypt.ml
	ocamlfind ocamlopt -c scrypt.ml
	ocamlfind ocamlmklib -v -ldopt -lscrypt -o scrypt scrypt.cmo scrypt_stubs.o

install:
	ocamlfind install scrypt META *.cmi *.cma

uninstall:
	ocamlfind remove scrypt

docs:
	rm -rf docs
	mkdir docs
	ocamlfind ocamldoc -html -d docs scrypt.mli

clean:
	rm -f *.cmi *.cmxa *.cma *.cmx *.cmo *.o
