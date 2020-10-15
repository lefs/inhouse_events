shared_examples_for 'a worker' do
  let(:worker) { described_class }
  it 'responds to :handle_event' do
    expect(worker).to respond_to(:handle_event)
  end
end
