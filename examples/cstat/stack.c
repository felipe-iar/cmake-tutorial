struct S {
  int *px;
} s;

void stack_global_field() {
 int i = 0;
 s.px = &i; //storing local address in global struct
}
