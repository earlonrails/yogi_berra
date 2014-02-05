require 'resque/failure/base'

module YogiBerra
  class Resque < Resque::Failure::Base
    def self.count
      Stat[:failed]
    end

    def save
      data = {
        :queue  => queue,
        :worker => worker.to_s,
        :args   => payload["args"],
        :class  => payload["class"].to_s
      }

      YogiBerra.exceptionize(exception, :resque => data)
    end
  end
end
