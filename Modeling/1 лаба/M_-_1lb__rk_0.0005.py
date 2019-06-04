from scipy  import integrate
from math import sqrt

#левая функция 
def func(y, x):
    return (y - x)

#первая функция
def f1(x, y):
    return (x + y)

#вторая функция
def f2(x, y):
    return (x*x + y*y)

def f2n(y, c, h):
    return (h*y*y - y + c)

#метод дихотомии 
def met_d(a, b, c, h):      
    fa = f2n(a, c, h)
    fb = f2n(b, c, h)
    while (abs(a-b)> 0.001):
        y = (a + b)/2
        fy = f2n(y, c, h)
        if ((fa * fy) < 0):
            b = y
            fb = fy
        else:
            a = y
            fa = fy
    return y

#метод Эйлера
def met_el(h, E1, E2):
    E1.append(0)
    E2.append(0)
    x = 0
    i = 0
    while x <= 10:
        y = E1[i] + h*(f1(E1[i], x))
        E1.append(y)
        y = E2[i] + h*(f2(E2[i], x))
        E2.append(y)
        i += 1
        x += h
        
#метод Рунге-Кутта второго порядка
def met_rk(h, RK1, RK2):
    RK1.append(0)
    RK2.append(0)
    x = 0
    i = 0
    while x <= 10:
        
        y = RK1[i] + h*f1(RK1[i] + (h/2)*f1(RK1[i], x), x + h/2)

        #y = RK1[i] + h*f1(RK1[i] + (h/2)*f1(RK1[i], x), x + h/2)

        #y = RK1[i] + h*((1-a)*f(RK1[i],x) + a*f(RK1[i]+(h/2)*f(RK1[i],x), x+(h/2)))
        RK1.append(y)
        y = RK2[i] + h*f2(RK2[i] + (h/2)*f2(RK2[i], x), x + h/2)
        RK2.append(y)
        i += 1
        x += h
       
    
#неявный метод Эйлера
#вряд ли работает правильно
def met_el_n(h, EN1, EN2):
    EN1.append(0)
    EN2.append(0)
    x = 0
    i = 0
    while x <= 10:
        y = (EN1[i] + h*(h+x))/(1 - h)
        EN1.append(y)
        c = EN2[i] + h*(x+h)*(x+h)
        D = abs(1 - 4*h*c)
        y = (1 - sqrt(D))/(2*h)
        #yd= met_d(0, 1000, c, h)
        #y = EN2[i] + h*yd
        EN2.append(y)
        i += 1
        x += h

#интегралы
def intgrl_1(h):
    return integrate.quad(lambda x: x, 0, h)

def intgrl_2(h):
    return integrate.quad(lambda x: x*x, 0, h)

def fun_1(x):
    return ((x*x)/2)+((x**3)/6)+((x**4)/24)

def fun_2(x):
    return (((x**3)/3)+((x**7)/63)+(2*(x**11)/2079)+((x**15)/59535))**2
    '''
    return (((x**3)/3)+((x**7)/63)+((2*x**11)/2079)+((4*x**15)/93555)+((2*x**19)/3393495)
            + ((x**15)/159535)+ ((4*x**19)/2488563)+((2*x**23)/86266215)+(4*x**23)/99411543
            +((4*x**27)/33418781550) + ((x**31)/109876902975))
    '''
    
#метод Пикара
def met_pkr(h, P1, P2):
    x = 0
    i = 0
    while x <= 10:
        yi = intgrl_1(x)[0]
        y = integrate.quad(fun_1, 0, x)[0]
        P1.append(y + yi)
        yi = intgrl_2(x)[0]
        y = integrate.quad(fun_2, 0, x)[0]
        P2.append(y + yi)
        i += 1
        x += h
        

H = 0.00005
'''
E1 = []
E2 = []
met_el(H, E1, E2)
'''
RK1 = []
RK2 = []
met_rk(H, RK1, RK2)
'''
EN1 = []
EN2 = []
met_el_n(H, EN1, EN2)

P1 = []
P2 = []
met_pkr(H, P1, P2)
'''
print('h = ', H)
'''
print("u'(x) = x + u")
print('x          rk')
x = 0
xo = 0 - H
i = 0
while x <= 3:
    #print(x, int(x), int(xo))
    #if (int(x) != int(xo) or x == 0):
    print('{:3.3f}  |{:10.3f}'.format(x,RK1[i]))
    x += H
    xo += H
    i += 1
'''
print()
print("u'(x) = x^2 + u^2")
print('x          rk')
x = 0
xo = 0 - H
i = 0
while x <= 3:
    #if (int(x) != int(xo)) or x == 0:
    print('{:3.5f}  |{:10.3f}'.format(x,RK2[i]))
    x += H
    xo += H
    i += 1
       
