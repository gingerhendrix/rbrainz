# $Id$
# Copyright (c) 2007, Philipp Wolfer
# All rights reserved.
# See LICENSE for permissions.

# Usefull helper methods which are used in different test classes.

# Converts a query string into a hash.
def query_string_to_hash query_string
  Hash[*query_string.scan(/(.+?)=(.*?)(?:&|$)/).flatten].each_value {|v|
    v.gsub!(/%([0-9a-f]{2})/i) { [$1.hex].pack 'C' }
  }
end