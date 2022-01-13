# Mathematical Annotation

?plotmath

?expression
?symbol

# plot symbols in plot titles and axis labels
# plot expressions in plot title

# exponential function
curve(dexp(x, rate = 2), from = 0, to = 3, 
      main = expression(f(x) == lambda * e^{-lambda * x}))

curve(dexp(x, rate = 2), from = 0, to = 3, 
      main = expression(paste(f(x) == lambda * e^{-lambda * x}, ", where ", lambda == 2)), 
      ylab = expression(f(x)), 
      xlab = expression(x))

# same in ggplot - use geom_function(fun = dexp) and specify range x using xlim
library(ggplot2)

ggplot() +
  geom_function(fun = dexp) +
  xlim(0, 3) +
  labs(title = expression(paste(f(x) == lambda * e^{-lambda * x}, ", where ", lambda == 2)), y = expression(f(x)))


# annotate regression results
?datasets
data(cars)
plot(cars)

m <- lm(dist ~ speed, data = cars)
coef(m)
summary(m)
sigma(m)

cars$pred_dist <- fitted(m)

ggplot(cars) +
  geom_point(aes(x = speed, y = dist)) +
  geom_line(aes(x = speed, y = pred_dist)) +
  ggtitle(expression(hat(beta)[1] == 3.9))

ggplot(cars) +
  geom_point(aes(x = speed, y = dist)) +
  geom_line(aes(x = speed, y = pred_dist)) +
  ggtitle(expression(hat(beta)[1] == 3.9 %+-% 0.42))


ggplot(cars) +
  geom_point(aes(x = speed, y = dist)) +
  geom_line(aes(x = speed, y = pred_dist)) +
  ggtitle(expression(paste(hat(beta)[1] == 3.9, ", ", sigma == 15.4)))

# source: https://r-graphics.org/recipe-annotate-text-math
# A normal curve
p <- ggplot(data.frame(x = c(-3,3)), aes(x = x)) +
  stat_function(fun = dnorm)

# parse = TRUE documented in geom_text()
p +
  annotate("text", x = 2, y = 0.3, parse = TRUE,
           label = "frac(1, sqrt(2 * pi)) * e ^ {-x^2 / 2}")

# cannot use parse = TRUE in labs or ggtitle


# using parse = TRUE
# documented in geom_text()
p <- ggplot(mtcars, aes(x = wt, y = mpg)) + 
  geom_point()

p + annotate("text", x = 4, y = 25, 
             label = "italic(R) ^ 2 == 0.75",
             parse = TRUE)

p + annotate("text", x = 4, y = 25,
             label = "paste(italic(R) ^ 2, \" = .75\")", 
             parse = TRUE)

plot.new()
plot.window(c(0,4), c(15,1))
text(1, 1, "universal", adj = 0); text(2.5, 1,  "\\042")
text(3, 1, expression(symbol("\042")))
text(1, 2, "existential", adj = 0); text(2.5, 2,  "\\044")
text(3, 2, expression(symbol("\044")))
text(1, 3, "suchthat", adj = 0); text(2.5, 3,  "\\047")
text(3, 3, expression(symbol("\047")))
text(1, 4, "therefore", adj = 0); text(2.5, 4,  "\\134")
text(3, 4, expression(symbol("\134")))
text(1, 5, "perpendicular", adj = 0); text(2.5, 5,  "\\136")
text(3, 5, expression(symbol("\136")))
text(1, 6, "circlemultiply", adj = 0); text(2.5, 6,  "\\304")
text(3, 6, expression(symbol("\304")))
text(1, 7, "circleplus", adj = 0); text(2.5, 7,  "\\305")
text(3, 7, expression(symbol("\305")))
text(1, 8, "emptyset", adj = 0); text(2.5, 8,  "\\306")
text(3, 8, expression(symbol("\306")))
text(1, 9, "angle", adj = 0); text(2.5, 9,  "\\320")
text(3, 9, expression(symbol("\320")))
text(1, 10, "leftangle", adj = 0); text(2.5, 10,  "\\341")
text(3, 10, expression(symbol("\341")))
text(1, 11, "rightangle", adj = 0); text(2.5, 11,  "\\361")
text(3, 11, expression(symbol("\361")))





# labs examples
p <- ggplot(mtcars, aes(mpg, wt, colour = cyl)) + geom_point()
p + labs(colour = "Cylinders")
p + labs(x = "New x label")

# The plot title appears at the top-left, with the subtitle
# display in smaller text underneath it
p + labs(title = "New plot title")
p + labs(title = "New plot title", subtitle = "A subtitle")

# The caption appears in the bottom-right, and is often used for
# sources, notes or copyright
p + labs(caption = "(based on data from ...)")

# The plot tag appears at the top-left, and is typically used
# for labelling a subplot with a letter.
p + labs(title = "title", tag = "A")
# If you want to remove a label, set it to NULL.
p +
  labs(title = "title") +
  labs(title = NULL)


# using latex2exp
library(latex2exp)

p +
  labs(title = TeX(r'($\gamma^\alpha$)'))
