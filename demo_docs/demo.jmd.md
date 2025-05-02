
# JKnit Demo

JKnit is a powerful literate programming tool which
allows coders to "knit" ccode chunks of arbitrary
language along with documentation.

Many language are built-in, including `python`:


```PYTHON
print('Hi from python!')
```

```
Hi from python!
```


`C`:


```C
#include <stdio.h>
int main() {
  puts("Hi from C!");
  return 0;
}
```

```
Hi from C!
```


`C++`:


```CPP
#include <iostream>
int main() {
  std::cout << "Hi from C++!\n";
  return 0;
}
```

```
Hi from C++!
```


`bash`:


```BASH
echo "Hi from bash!"
```

```
Hi from bash!
```


`Oak` (my pet language):


```OAK
include!("std/io.oak");
let main() -> i32 {
  print("Hi from Oak!\n");
  return 0i32;
}
```

```
```


And, if you want to extend it, literally any other language!


