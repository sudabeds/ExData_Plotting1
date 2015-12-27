
## makeCacheMatrix is a function that stores a list of four functions as follows:
##set the value of a matrix
##get the value of a  matrix
##set the value of the invers of the matrix
##get the value of the invers of the matrix

##to start store this function in a variable like a (a <- makeCacheMatrix(x), x is the 
##matrix that you want to calculate its invers)
##I found this link very helpful:https://github.com/DanieleP/PA2-clarifying_instructions

makeCacheMatrix <- function(x = matrix()) {
  m <- NULL
  set <- function(y) {
    x <<- y
    m <<- NULL
  }
  get <- function() x
  setinv <- function(inv) m <<- inv
  getinv <- function() m
  list(set = set, get = get,
       setinv = setinv,
       getinv = getinv)

}


## Input of cacheSolve is the object where makeCacheMAtrix() is stored 
##(I chose "a" look at the above comments). I hope this have been clear enough! Thanks for your
##time and good luck with your studying!

cacheSolve <- function(x, ...) {
  m <- x$getinv()
  if(!is.null(m)) {
    message("getting cached data")
    return(m)
  }
  data <- x$get()
  m <- solve(data, ...)
  x$setinv(m)
  m
}
