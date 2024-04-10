void main(){
    x = 5;
    y = 10;
    z = x + y;
    if(x > y){
        print("x is greater than y");
    }
    else if (x == y)
    {
        print("x is equal to y");
    }
    else{
        print("y is greater than x");
    }

    while (z > 0)
    {
        print(z);
        z = z - 1;
        switch (z)
        {
        case 1:
            x = 0;
            break;
        
        default:
            break;
        }
    }
    int count = 10;
    int i;
    for (i = 0; i < count; i = i + 1)
    {
        print("Hello World!");
    }
}