# Run with < rspec spec/controllers/events_controller_spec.rb >

# frozen_string_literal: true

require 'rails_helper'

RSpec.describe EventsController, type: :controller do
  describe '#index' do
    context 'when filter-by parameter is present' do
      it 'calls filter_events method' do
        allow(controller).to receive(:filter_events)
        get :index, params: { 'filter-by' => 'some_value' }
        expect(controller).to have_received(:filter_events)
      end

      it 'assigns the filtered events to @events' do
        filtered_events = [instance_double(Event), instance_double(Event)]
        allow(controller).to receive(:filter_events).and_return(filtered_events)
        get :index, params: { 'filter-by' => 'some_value' }
        expect(assigns(:events)).to eq(filtered_events)
      end
    end

    context 'when filter-by parameter is not present' do
      it 'assigns all events to @events' do
        events = [instance_double(Event), instance_double(Event)]
        allow(Event).to receive(:all).and_return(events)
        get :index
        expect(assigns(:events)).to eq(events)
      end
    end
  end

  describe '#show' do
    it 'assigns the requested event to @event' do
      event = instance_double(Event, id: 1)
      allow(Event).to receive(:find).with('1').and_return(event)
      get :show, params: { id: 1 }
      expect(assigns(:event)).to eq(event)
    end
  end
end
