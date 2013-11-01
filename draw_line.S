.global draw_line

.data
	sx: .long 0
	sy: .long 0
	dx: .long 0
	dy: .long 0
	err: .long 0
	x: .long 0
	y: .long 0
	e2: .long 0
	

.text
draw_line:
	pusha
	movl %esp, %ebp

// Mit diesen Makros koennen Sie auf die Parameter zugreifen.
// Beispiel: mov x0, %eax

#define x0 36(%ebp)
#define y0 40(%ebp)
#define x1 44(%ebp)
#define y1 48(%ebp)

	movl x1, %eax
	subl x0, %eax
	cmpl $0, %eax
	jge .ISPOS
	imull $-1, %eax	
.ISPOS:	
	movl %eax, dx
	movl x0, %ebx
	cmpl x1, %ebx
	jl .IF
	movl $-1, sx 
	jmp .ENDIF
.IF:
	movl $1, sx
.ENDIF:

	movl y1, %eax
	subl y0, %eax
	cmpl $0, %eax
	jl .NEG
	imull $-1, %eax
.NEG:
	movl %eax, dy

	movl y0, %eax
	cmpl y1, %eax
	jl .IF1
	movl $-1, sy
	jmp .ENDIF2
.IF1:
	movl $1, sy
.ENDIF2:

	movl dx, %eax
	addl dy, %eax
	movl %eax, err

	movl x0, %eax
	movl %eax, x
	movl y0, %eax
	movl %eax, y	
.WHILE:
	movl y, %eax
	imull width, %eax
	addl x, %eax
	movb $255, buf(%eax)
	
	movl x, %ebx
	cmpl x1, %ebx
	jne .CONT
	movl y, %ebx
	cmpl y1, %ebx
	je .BREAK
.CONT:
	movl err, %ebx
	imull $2, %ebx # ecx ist e2
	movl %ebx, e2
	cmpl dy, %ebx
	jle .IF2
	movl err, %ebx
	addl dy, %ebx
	movl %ebx, err

	movl x, %ebx
	addl sx, %ebx
	movl %ebx, x
.IF2:
	movl e2, %ebx
	cmpl dx, %ebx
	jge .WHILE
	movl err, %eax
	addl dx, %eax
	movl %eax, err
	movl y, %ebx
	addl sy, %ebx
	movl %ebx, y
	jmp .WHILE
.BREAK:
	movl %ebp, %esp
	popa
	ret
