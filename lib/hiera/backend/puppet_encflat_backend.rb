class Hiera
  module Backend
    class Puppet_encflat_backend
      def initialize
        Hiera.debug("Hiera Puppet backend starting")
      end

      def lookup(key, scope, order_override, resolution_type)
        answer = Backend.empty_answer(resolution_type)

        Hiera.debug("Looking up #{key} in Puppet ENC backend")

        # ENC lookup hack
        calling_class = scope.resource.name.to_s.downcase.split("::").join("_")
        calling_module = scope.resource.name.to_s.downcase.split("::").first

        # Look up the class var
        if answer = scope[calling_class + "_" + key]
          Hiera.debug("Found #{calling_class}: #{answer}")
        elsif answer = scope[calling_module + "_" + key]
          Hiera.debug("Found #{calling_module}: #{answer}")
        end

        answer = nil if answer == :undefined

        answer
      end
    end
  end
end
