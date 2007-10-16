# $Id$
#
# Author::    Nigel Graham (mailto:nigel_graham@rubyforge.org)
# Copyright:: Copyright (c) 2007, Nigel Graham, Philipp Wolfer
# License::   RBrainz is free software distributed under a BSD style license.
#             See LICENSE[file:../LICENSE.html] for permissions.
# Notes::     Based on http://textsnippets.com/posts/show/1075 and
#             http://segment7.net/projects/ruby/snippets/digest_auth.rb

require 'digest/md5'
require 'net/http'

module Net # :nodoc:
  module HTTPHeader # :nodoc:
    @@nonce_count = -1
    CNONCE = Digest::MD5.new.update("%x" % (Time.now.to_i + rand(65535))).hexdigest
    
    def select_auth(user,password,response)
      response['www-authenticate'] =~ /^(\w+) (.*)/
      auth_type = $1
      case auth_type
        when 'Digest'
          digest_auth(user,password,response)
          return true
        when 'Basic'
          basic_auth(user,password)
          return true
      end
      return false
    end
    
    def proxy_select_auth(user, password, response)
      response['proxy-authenticate'] =~ /^(\w+) (.*)/
      auth_type = $1
      case auth_type
        when 'Digest'
          proxy_digest_auth(user,password,response)
          return true
        when 'Basic'
          proxy_basic_auth(user,password)
          return true
      end
      return false
    end
    
    def digest_auth(user, password, response)
      @header['Authorization'] = digest_encode(response['www-authenticate'], user, password)
    end
    
    def proxy_digest_auth(user, password, response)
      @header['Proxy-Authorization'] = digest_encode(response['proxy-authenticate'], user, password)
    end
    
    def digest_encode(authenticate, user, password)
      @@nonce_count += 1
      authenticate =~ /^(\w+) (.*)/
      
      params = {}
      $2.gsub(/(\w+)="(.*?)"/) { params[$1] = $2 }

      a_1 = "#{user}:#{params['realm']}:#{password}"
      a_2 = "#{@method}:#{@path}"
      request_digest = ''
      request_digest << Digest::MD5.new.update(a_1).hexdigest
      request_digest << ':' << params['nonce']
      if params['qop']
        request_digest << ':' << ('%08x' % @@nonce_count)
        request_digest << ':' << CNONCE
        request_digest << ':' << params['qop'] 
      end
      request_digest << ':' << Digest::MD5.new.update(a_2).hexdigest

      header = []
      header << "Digest username=\"#{user}\""
      header << "realm=\"#{params['realm']}\""

      header << "qop=#{params['qop']}" if params['qop']

      header << "algorithm=MD5"
      header << "uri=\"#{@path}\""
      header << "nonce=\"#{params['nonce']}\""
      header << "nc=#{'%08x' % @@nonce_count}" if params['qop']
      header << "cnonce=\"#{CNONCE}\"" if params['qop']
      header << "response=\"#{Digest::MD5.new.update(request_digest).hexdigest}\""
      
      return header
    end
  end
end