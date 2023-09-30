Routine { 
	Crone.setEngine("Engine_Scapes");

	
engine.grain_delay(1, bar * 6.25)
engine.grain_pulse_rate(1, 1.5 / dt)
engine.grain_dur(1, dt * 1.5 * 1.5)
engine.grain_rate(1, 2.0)

engine.grain_delay(2, bar)
engine.grain_pulse_rate(2, 2.25 / dt)
engine.grain_dur(2, dt / 2.25 * 1.5)
engine.grain_rate(2, 1.0)

engine.grain_delay(3, bar * 7)
engine.grain_pulse_rate(3, 2.5 / dt)
engine.grain_dur(3, dt / 2.5 * 1.5)
engine.grain_rate(3, 1.5)

engine.grain_delay(4, form)
engine.grain_pulse_rate(4, 1/bar)
engine.grain_dur(4, bar * 0.8)
engine.grain_rate(4, 0.5)

engine.grain_amp(1, 0.15)
engine.grain_amp(2, 0.2)
engine.grain_amp(3, 0.2)
engine.grain_amp(4, 0.3)
