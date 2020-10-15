shared_examples_for 'a backend' do
  it { should respond_to(:publish).with(1).argument }
  it { should respond_to(:verify_credentials) }
end
