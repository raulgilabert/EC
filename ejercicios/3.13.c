int v[n] = {...}

int main() {
    int suma, i, offset;

    suma = 0;
    i = 0;
    offset = 0;

    while (i < n) {

	suma += *(v + offset);

	offset += 4;
	++i;
    }
}
