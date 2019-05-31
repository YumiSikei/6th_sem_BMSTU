;уменьшить все элементы на К

(defun subs_k(lst, k) 
	(mapcar #'(lambda(x) (- x k)
			)
		lst)
)

(defun subs(lst, k)
	(cond
		((null lst) nil)
		(t (cons (- (car lst) k) (subs (cdr lst) k)))
	)
)

;умножить нечетные элементы на -1
(defun mult-1(lst)
	(cond
		((null lst) nil)
		((evenp (car lst)) (cons (* (car lst) -1) (mult-1 (cdr lst)) ))
		(t (cons (car lst) (mult-1 (cdr lst) )))
		)
)

(defun mult-1_m(lst)
	(mapcar #'(lambda(x) (cond
							((evenp x) (* x -1))
							(t x)
						)
			)
		lst)
)

;если первый элемент списка больше 10, то каждый элемент уменьшить на k, а после нечетные
;элементы умножить на -1
(defun task(lst, k)
	(cond 
		(( > (car lst) 10) (mult-1_m (subs_k lst k)))
		(t lst)
	)
)

;преобразования смешанного одноуровневого списка в численный
(defun get_num(lst)
	(cond
		((null lst) nil)
		((numberp (car lst)) (cons (car lst) (get_num (cdr lst))))
		(t (get_num (cdr lst)))
	)
)

(defun func(lst, k)
	(task (get_num lst) k))