
# Represents a duration in milliseconds.
class Duration < Numeric

	def initialize(milliseconds=0)
		@ms = milliseconds.to_i
	end

	def days
		to_i / 86400000
	end

	def hours
		to_i / 3600000 % 24
	end

	def minutes
		to_i / 60000 % 60
	end

	def seconds
		to_i / 1000 % 60
	end

	def milliseconds
		to_i % 1000
	end

	def to_i
		@ms
	end

	def to_f
		@ms.to_f
	end

	def coerce(numeric)
		if numeric.is_a?(Integer)
			[numeric, to_i]
		else
			[Float.induced_from(numeric), to_f]
		end
	end

#	def method_missing(m, *args)
#		if ['%'.to_sym, '+'.to_sym, '-'.to_sym, '*'.to_sym, '/'.to_sym].include?(m)
#			self.class.new(@ms.send(m, *args))
#		end
#	end

	def <=> other
		to_i <=> other
	end
	
	def % other
		Duration.new(to_i % other)
	end

	def + other
		Duration.new(to_i + other)
	end

	def - other
		Duration.new(to_i - other)
	end

	def * other
		Duration.new(to_i * other)
	end

	def / other
		Duration.new(to_i / other)
	end

	def ** other
		Duration.new(to_i ** other)
	end

end

require 'delegate'

#class Duration < DelegateClass(Fixnum)
#
#	def x_method_missing(m, *args, &block)
#		if block_given?
#			result = super m, *args
#		else
#			result = super m, *args, &block
#		end
#		result.is_a?(Integer) ? Duration.new(result) : result
#	end
#
#end


