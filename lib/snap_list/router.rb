module SnapList
  class Router
    attr_reader :params

    def initialize(route, pattern)
      @route = route.to_s
      @pattern = pattern.to_s
      @params = {}
    end

    def match?
      pattern = @pattern.split("/")
      route = @route.split("/")

      if route.count == pattern.count
        params = []

        match_result = pattern.each_with_index.map do |x, i|
          result = (x == route[i] || x[0] == ":")

          if x[0] == ":" && result
            param_name = x[1..-1].to_sym
            @params[param_name] = route[i]
          end

          result
        end

        return true if match_result.uniq == [true]
      end

      false
    end
  end
end
