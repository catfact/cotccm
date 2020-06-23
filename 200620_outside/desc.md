i was asked about a technical run-down so here it is.

(most parameters are not chosen with any particular care, except with regards to timing of events, and total duration...)

electric viola feeds L/R inputs through different amplification chains.  (L: dark and static, R: brighter, varied, starting quiet.)

supercollider runs on thinkpad, with 2x2 audio interface, alongisde softcut, JACK, OBS.

things happen under program control:

1. for 120 seconds, computer makes no sound. L input is polled and analyzed, each "note event" collecting amplitude, pitch, "clarity," and spectral flatness measures. (this is an autocorrelation-based pitch tracker, where "clarity" is the normalized height of the autocorrelation peak.)

2. the table of timestamped pitch/amp/clar/flat events is sorted by clarity. a sequence of oscillators begins to play. each odsc is three sinewaves at octaves; their balancee and panning is influenced by the captured "note event" characteristics. (this mapping is seriously ad-hoc.)

3. 32 seconds of L/R audio is recorded, and the first few seconds begin to loop. loop amplitudes are modulated by feedback-sine LFOs, running at rates harmonically related to loop sizes.


other things occur due to manual code execution (i believe the kids call this "alive codings"):

- a softcut process is engaged, with 2 voices in feedback, taking alternate L/R inputs

- softcut rates are modulated by random JI intervals

- loop rate / timing / levels are adjusted

also, in the analog realm:

gain controls are adjusted. we attempt to follow accidental harmonic and rhyhmic trajectories. our thoughts and hands slide and scrape. we encounter both pain and lightness. a fern waves. 
 
