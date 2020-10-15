require 'support/backends/test'
require 'shared_examples/backends'

module InhouseEvents
  module Backends
    describe Test do
      it_behaves_like 'a backend'
    end
  end
end
