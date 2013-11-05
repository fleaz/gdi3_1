.global draw_line

.data
	sx: .long 0		#
	sy: .long 0		#
	dx: .long 0		#
	dy: .long 0		#
	err: .long 0		#
	x: .long 0		#
	y: .long 0		#
	e2: .long 0		#
	

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

	movl x1, %eax		#lade x1 in eax
	subl x0, %eax		#eax(x1)-x0 ergbs in register eax
	cmpl $0, %eax		#vergleiche 0 mit eax. wenn...
	jge .ISPOS		#...eax >= 0 sprung zu .ISPOS
	imull $-1, %eax		#...eax < 0 ändere Vorzeichen
.ISPOS:				#
	movl %eax, dx		#...und speicher eax in dx-variable.
	movl x0, %ebx		#lade x0 in ebx
	cmpl x1, %ebx		#vergleiche x1 mit ebx(x0).wenn... 
	jl .IF			#...ebx(xo)<x1 sprung zu .IF
	movl $-1, sx 		#...x0>=x1 speichere -1 in sx
	jmp .ENDIF		#sprung zu .ENDIF 
.IF:				#
	movl $1, sx		#speichere 1 in sx
.ENDIF:				#

	movl y1, %eax		#lade y1 in eax
	subl y0, %eax		#eax(y1)-y0 ergbs in register eax
	cmpl $0, %eax		#vergleiche 0 mit eax. wenn...
	jl .NEG			#...eax<0 sprung zu .NEG
	imull $-1, %eax		#...eax>=0 ändere Vorzeichen
.NEG:				#
	movl %eax, dy		#neg Zahl in eax wird in dy gespeichert

	movl y0, %eax		#lade y0 in eax
	cmpl y1, %eax		#vergleiche y1 mit eax(y0)
	jl .IF1			#eax(y0)<y1 sprung zu IF1
	movl $-1, sy		#speichere -1 in sy
	jmp .ENDIF2		#sprung zu.ENDIF2
.IF1:				#
	movl $1, sy		#speichere 1 in sy
.ENDIF2:			#
	
	movl dx, %eax		#dx in eax
	addl dy, %eax		#dy+eax(dx)
	movl %eax, err		#speichere addition in err

	movl x0, %eax		#x=x0...
	movl %eax, x		#... 
	movl y0, %eax		#y=y0...
        movl %eax, y		#... 
.WHILE:				#While (true)/(1)
	movl y, %eax		#An dem pixel (x,y)...
	imull width, %eax	#...zu erreichen mit...
	addl x, %eax		#...buf+(y*width)+x
	movb $255, buf(%eax)	#...setze das pixel weiß
	
	movl x, %ebx		#lade x in ebx
	cmpl x1, %ebx		#Vergleiche x1 mit ebx(x)
	jne .CONT		#x!=x1 sprung zu .CONT
	movl y, %ebx		#lade y in ebx
	cmpl y1, %ebx		#vergleiche y1 mit ebx(y)
	je .BREAK		#x==x1 && y==y1 spr zu .Break
.CONT:				#
	movl err, %ebx		#lade err in ebx
	imull $2, %ebx          #2*ebx(err)...     
	movl %ebx, e2		#...erg in e2-variable
	cmpl dy, %ebx		#
	jle .IF2		#ebx(e2)<=dy sprung zu .IF2
	movl err, %ebx		#ebx(e2)>dy...
	addl dy, %ebx		#...dy+ebx(err)...
	movl %ebx, err		#und sichere in err

	movl x, %ebx		#x=x+sx
	addl sx, %ebx		#...
	movl %ebx, x		#...
.IF2:				#
	movl e2, %ebx		#lade e2 in ebx
	cmpl dx, %ebx		#
	jge .WHILE		#ebx(e2)>=dx sprung zu .WHILE
	movl err, %eax		#err=err+dx
	addl dx, %eax		#...
	movl %eax, err		#...
	movl y, %ebx		#y=y+sy
	addl sy, %ebx		#...
	movl %ebx, y		#...
	jmp .WHILE		#sprung zu .WHILE
.BREAK:				#
	movl %ebp, %esp		
	popa			
	ret			
