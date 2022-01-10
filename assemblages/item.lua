return function(e, x, y, item)
	e
	  :give("position", x, y)
	  :give("item", type(item) == "string" and {type = item} or item)
end
