let x = 200 in (let y = x * x in x + y)

(* This is how you define a function *)
let cube x = x * x * x
let neg x = x < 0
let isVowel1 c =
  c = 'a' || c = 'e' || c  = 'i' || c = 'o' || c = 'u'
let isSumTen a b =
  a + b = 10
(* To define a recursive function, you need to specify the keyword rec *)
let rec factorial1 x =
  if x = 1 then 1 else x * factorial1 (x - 1)
let rec gcd1 a b =
  if b = 0 then a else gcd1 b (a mod b)
(* Nested  if else construction: Not the best example though :) *)
let rec power1 x n =
  if n = 0 then 1 else
    if n = 1 then x else
      x * power1 x (n - 1)
let isConsonant c = not (isVowel1 c)
(* Ladies and gentlemen, please welcome your majesty pattern matching :D *) 
let rec factorial a =
  match a with
    1 -> 1
  | _ -> a * factorial (a - 1)
let isVowel c =
  match c with
    'a' | 'e' | 'i' | 'o' | 'u' -> true
    | _ -> false

let rec gcd a b =
  match b with
    0 -> a
  | _ -> gcd b (a mod b)

let not a =
  match a with
    false -> true
  | true -> false

let rec sum a =
  match a with
    1 -> 1
  | _ -> a + sum (a - 1)

let rec power x n =
  match n with
    0 -> 1
  | 1 -> x
  | _ -> x * power x (n - 1)

(* Just a nested match example. The result will be 5 *)
let a =
  match 1 + 1 with
    2 -> ( match 2 + 2 with
             3 -> 4
           | 4 -> 5
           | _ -> 0
         )
  | _ -> 01
         

let isLower c =
  match c with
    'a' .. 'z' -> true
  | _ -> false

(* This one is pretty much awesome. Using con(::) to deconstruct the list. *)
let rec length_bad l =
  match l with
    [] -> 0
  | h::t -> length_bad t + 1

let rec add_list l =
  match l with
    [] -> 0
  | h::t -> h + add_list t

(* More advanced example, needs less memory *)
let rec length_inner l n =
  match l with
    [] -> n
  | h::t -> length_inner t (n + 1)

let length l = length_inner l 0

(* A little tricky one *)
let rec odd_elements l =
  match l with
    [] -> []
  | [h] -> [h]
  | h::_::t -> h :: odd_elements t
                                 
(* Better version *)
let rec odd_elements_refined l =
  match l with
    h::_::t -> h :: odd_elements_refined t
  | _ -> l

(* Coooool *)
let rec append a b =
  match a with
    [] -> b
  | h::t -> h :: append t b
  
let rec reverse a =
  match a with
    [] -> []
  | h::t -> reverse t @ [h]

let rec reverse_inner l a =
  match l with
    [] -> a
  | h::t -> reverse_inner t (h :: a)

let reverse_t l =
  reverse_inner l []
                          
(* Simple functions to take/drop first n elements of the list *)
let rec take n l =
  if n = 0 then [] else
    match l with
      [] -> []
    | h::t -> h :: take (n - 1) t

let rec drop n l =
  if n = 0 then l else
    match l with
      [] -> []
    | h::t -> drop (n - 1) t

(* Counting the number of true elements - looks awesome. Second version is tail recurisve one *)                   
let rec count_true l =
  match l with
    [] -> 0
  | true::t -> 1 + count_true t
  | _::t -> count_true t
                       
let rec count_true_inner l n =
  match l with
    [] -> n
  | true::t -> count_true_inner t (n + 1)
  | _::t -> count_true_inner t n

let count_true_tailrec l =
  count_true_inner l 0

(* Simple palindrome ones *)
let build_palindrome l =
  l @ reverse l

let check_palindrome l =
  l = reverse l

(* Drop last, 2 versions *)
let rec drop_last l =
  match l with
    [] -> []
  | [_] -> []
  | h::t -> h :: drop_last t

let rec drop_last_inner l acc =
  match l with
    [] -> []
  | [_] -> reverse_t acc
  | h::t -> drop_last_inner t (h :: acc)

let rec drop_last_tailrec l =
  drop_last_inner l []

(* Check if an element is in the list *)
let rec member n l =
  match l with
    [] -> false
  | h::t -> h = n || member n t

(* Remove duplicate elements, nice that you build on top of simpler function - member *)
let rec make_set l =
  match l with
    [] -> []
  | h::t -> if member h t then make_set t else h :: make_set t

(* Insertion sort. Understanding how to break the problem into small pieces using FP logic *)
(* For reverse order need to simply change <= with >= *)
let rec insert x l =
  match l with
    [] -> [x]
  | h::t ->
     if x <= h
     then x :: h :: t
     else h :: insert x t

let rec insert_sort l =
  match l with
    [] -> []
  | h::t -> insert h (insert_sort t)

(* Merge sort. Matching on more than one thing. Using length, take and drop we wrote *)
let rec merge x y =
  match x, y with
    [], l -> l
  | l, [] -> l
  | hx::tx, hy::ty ->
     if hx < hy
     then hx :: merge tx (hy :: ty)
     else hy :: merge (hx :: tx) ty

let rec merge_sort l =
  match l with
    [] -> []
  | [x] -> [x]
  | _ ->
     let half = length l / 2 in
     let left = take half l in
     let right = drop half l in
     merge (merge_sort left) (merge_sort right)

(* Function to check if the list is sorted *)
let rec is_sorted l =
  match l with
    a::b::t -> a <= b && is_sorted (b :: t)
  | _ -> true

(* Our own map function *)
let rec map f l =
  match l with
    [] -> []
  | h::t -> f h :: map f t

let is_even x =
  x mod 2 = 0

let evens_traditional l =
  map is_even l

(* Simple function using inline arrow(anonymous) function and map *)
let evens l =
  map (fun x -> x mod 2 = 0) l

(* More advanced merge sort. Giving compare function as an argument *)
let greater a b =
  a >= b
      
let rec merge_adv cmp a b =
  match a, b with
    [], l -> l
  | l, [] -> l
  | ha::ta, hb::tb ->
     if cmp ha hb
     then ha :: merge_adv cmp ta (hb::tb)
     else hb :: merge_adv cmp (ha::ta) tb
       
let rec merge_sort_adv cmp l =
  match l with
    [] -> []
  | [x] -> [x]
  | _ ->
     let half = length l / 2 in
     let left = take half l in
     let right = drop half l in
     merge_adv cmp (merge_sort_adv cmp left) (merge_sort_adv cmp right)

(* There is a shorthand of turning any legal operator into a function. Just wrap it with parantheses. E.g.  *)
(* merge_sort_adv ( <= ) [5; 4; 6; 2; 1] -> Ascending sort *)
(* OR *)
(* merge_sort_adv ( >= ) [5; 4; 6; 2; 1] -> Descending sort *)

let rec calm l =
  match l with
    [] -> []
  | '!'::t -> '.' :: t
  | h::t -> h :: calm t

let calm_char c =
  match c with
    '!' -> '.'
  | _ -> c

let calm_map l =
  map calm_char l

let clip a =
  if a < 1 then 1 else
    if a > 10 then 10 else a

let cliplist l =
  map clip l

let cliplist_anon l =
  map
    (fun x ->
      if x < 1 then 1 else
        if x > 10 then 10 else x)
    l
(* A function to apply the function f with the argument init_arg n times *)
let rec apply f n init_arg =
  if n = 0
  then init_arg
  else f (apply f (n - 1) init_arg)
  
let power_applied a b =
  apply (fun x -> x * a) b 1

(* A filter function and a usage to filter evens *)        
let rec filter f l =
  match l with
    [] -> []
  | h::t ->
     if f h
     then h :: filter f t
     else filter f t

let evens l =
  filter (fun x -> x mod 2 = 0) l

(* Check if some condition is true for all elements *)         
let rec for_all f l =
  match l with
    [] -> true
  | h::t -> f h && for_all f t

let all_positive l =
  for_all (fun x -> x >= 0) l

let rec mapl f l =
  match l with
    [] -> []
  | h::t -> map f h :: mapl f t


(* Partial application. You gan give just one argument to the 2 or more arg. function  *)
(* To get a new function with 1 less args *)               
let add x y = x + y
(* This is the same as *)
let add = fun x -> fun y -> x + y
(* So we do smth like this *)
let f = add 6
(* Now we can use f with 1 arg. E. g. f 5 = 11 *)

(* We can use that fact for doing smth like *)
let map_add_six l = map (add 6) l
let double_map l = map (( * ) 2) l

(* We can rewrite mapping over 'a list list map1 func this 2 ways *)
let rec mapl_1 f l = map (map f) l
let rec mapl_2 f = map (map f)

(* Check if element x is in all lists of ls *)
let rec member_all x ls =
  not (member false (map (member x) ls))
(* Another way *)
let rec member_all_clean x ls =
  let booleans = map (member x) ls in
  not (member false booleans)

let mapll f l = mapl (mapl f) l
(* OR *)
let rec mapll f = map (map (map f)) 

let truncate_l n l =
  if length l >= n then take n l else l
(* Or using take version in exceptions.ml *)
(* let truncate_l_ex n l = *)
(*   try take n l with Invalid_argument "take" -> l *)
                      
let rec truncate n ll =
  map (truncate_l n) ll
      (* Or use truncate_l_ex *)

let first_element_l n l =
  match l with
    [] -> n
  | h::_ -> h
      
let first_elements n ll =
  map (first_element_l n) ll
