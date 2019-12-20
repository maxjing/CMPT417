% Instance vocabulary[price, buy, free, n, m], an instance structure consists of: 

% n: the number of pizzas
% m: the number of coupons
% price: [n] -> N, giving the prices for each of the n pizzas
% buy: [m] -> N, giving the number of paid pizzas required to justify using each of the m coupons
% free: [m] -> N, giving the number of free pizzas that can be obtained by using each of the m coupons
% cost bound k ∈ N

int: n;

set of int: Pizzas = 1 .. n;
array[Pizzas] of int: price;
int: m;


array[Coupons] of int: buy;
array[Coupons] of int: free;

set of int: Coupons = 1 .. m;

% Vocabulary symbols:

% Paid: the set of pizzas will be paid for
% Used: the set of coupons that will be used
% Justifies(c, p): holds if pizza p is one of the pizzas we will pay for to justify using coupon c
% UsedFor(c, p): holds if p is one of the pizzas we get free by using coupon c
array[Coupons, Pizzas] of var bool: UsedFor;
array[Coupons, Pizzas] of var bool: Justifies;


var set of Pizzas: Paid;
var set of Coupons: Used;

var int: cost = sum(i in Pizzas) (bool2int(i in Paid) * price[i]);

%Formulas to satisfy(constraints)
% 1. We pay for exactly the pizzas that we don't get free by using coupons:
constraint forall(p in Pizzas)((p in Paid) <-> not exists(c in Used)(UsedFor[c, p]));

%2. Used is the set of coupons that we use:
constraint forall(c in Coupons)((c in Used) <-> exists(p in Pizzas)(UsedFor[c,p]));

%3. Any coupon that is used must be justified by sufficiently many purchased pizzas:
constraint forall(c in Coupons) ((c in Used) -> sum(p in Pizzas)(bool2int(Justifies[c,p] )) >=buy[c]);

%4. The number of pizzas any coupon is used for is not more than the number it allows us to get free:
constraint forall(c in Coupons)((c in Used) -> (sum(p in Pizzas)(bool2int(UsedFor[c, p])) <= free[c]));

%5. Each free pizza costs at most as much as the cheapest pizza used to justify use of the relevant coupon:
constraint forall(c in Coupons) (
  forall (p1, p2 in Pizzas where p1 != p2) (
    ((UsedFor[c,p1] /\ Justifies[c,p2]) -> (price[p1] <= price[p2])) ));
%6. We pay for every pizza used to justify use of a coupon:
constraint forall (p in Pizzas)(
  forall(c in Coupons) (
    Justifies[c,p] -> (p in Paid)));
    
%7. The total cost is not too large:
constraint cost <= sum(p in Pizzas)(price[p]);

%8. We also must require that Justifies(c, p) and UsedFor(c, p) hold only of pairs consisting of a coupon and a pizza. (For example, if there are 3 coupons and 5 pizzas, we would not want Justifies(4, 5) to hold, as we might then be getting pizza 5 free by applying the non-existent coupon number 4.)
constraint forall(c in Coupons) (
    forall(p in Pizzas) (
      (Justifies[c,p]) -> (
         ((1 <= c ) /\ (c <= m)) /\ ((1 <= p) /\ (p <= n)))
    ));
    
constraint forall(c in Coupons) (
    forall(p in Pizzas) (
      (UsedFor[c,p]) -> (
         ((1 <= c ) /\ (c <= m)) /\ ((1 <= p) /\ (p <= n)))
    ));  

%9. Pizza can be used only once to justify a coupon
constraint forall(c in Coupons) (
  forall(p in Pizzas)
    (Justifies[c,p] -> not exists(c2 in Coupons where c != c2)(Justifies[c2,p])
));


solve minimize cost;
output ["cost(" ++ show(cost) ++ ")\n"]
