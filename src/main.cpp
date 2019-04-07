// Copyright (c) 2019 Gino Latorilla.

#define UNUSED_VAR(__X__) do{ static_cast<void>(__X__); } while(0);

int main(int argc, char* argv[])
{
    UNUSED_VAR(argc);
    UNUSED_VAR(argv);
    return 0;
}

#undef UNUSED_VAR
