int *p, *q, suma:
p = V;
q = V + N;
suma = 0;

do {
    suma += *p;
    *p++;
} while (p != q);
