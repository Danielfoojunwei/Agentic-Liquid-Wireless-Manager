# UHCI Net-Intel: Universal Heterogeneous Connectivity Intelligence

**AI-powered wireless network manager for laptops and PCs using SAC-LTC (Soft Actor-Critic with Liquid Time-Constant cells).**

Derived from [PreceptualAI UHCI](https://github.com/Danielfoojunwei/PreceptualAI-Universal-Heterogeneous-Connectivity-Intelligence-UHCI-) — simplified from a massive telecom AI system into a practical tool that runs on your laptop to intelligently manage Wi-Fi and 3G/4G/5G hotspot switching.

## What It Does

- **Diagnoses** your wireless environment — signal quality, noise, channel congestion, interference
- **Optimizes** automatically — switches networks, DNS, flushes cache, restarts adapter when needed
- **Explains** in plain English — "Your WiFi is slow because 5 networks are fighting for your channel"
- **Detects presence** — senses human movement through Wi-Fi signal fluctuations
- **Navigates** — tells you which direction to move for better signal
- **Monitors** continuously with live sentinel mode

## Architecture

```
Raw Network Data (RSSI, noise, latency, throughput, loss, congestion)
    → Normalize to [0,1] (8 features)
    → LTC Cell (continuous-time ODE, hidden_dim=32)
        τ(x)·dh/dt = -h + tanh(W_h·h + W_x·x + b)
    → KAN Actor (Kolmogorov-Arnold Network, interpretable)
        KANLinear(32→16) → LayerNorm → KANLinear(16→N) → Softmax
    → Action probabilities + Explainable reasoning
```

**Total: ~17K parameters. CPU-only. <30MB RAM. No GPU needed.**

## Key Features

| Feature | Description |
|---------|-------------|
| **SAC-LTC Intelligence** | Trained with real ITU-R/3GPP RF physics models, not mocks |
| **Cross-Platform** | macOS, Linux/Ubuntu, Windows |
| **Hotspot Management** | Auto-detects iPhone/Android hotspots, manages Wi-Fi ↔ cellular switching |
| **RF Explainability** | Deep analysis under the hood, plain English conclusions on the surface |
| **Channel Congestion Maps** | Shows exactly who is competing for your airspace |
| **Interference Classification** | Identifies microwave, Bluetooth, radar, competing APs |
| **Presence Detection** | Senses movement through RSSI variance analysis with LTC temporal intelligence |
| **Navigation Guidance** | "Walk 2 meters to your right for better signal" |
| **Spatial Calibration** | Maps AP directions to front/back/left/right relative to you |
| **Live Sentinel Mode** | Continuous monitoring with proactive alerts |

## Hardware Requirements

```
REQUIRED:
  Wi-Fi adapter (built-in or USB)
  Internet connection (Wi-Fi or hotspot)
  Terminal: Bash (macOS/Linux) or PowerShell (Windows)
  Python 3.8+

OPTIONAL:
  PyTorch + NumPy — for SAC-LTC AI decisions (falls back to heuristics without)
  Admin/sudo — for DNS optimization, DHCP renewal, adapter restart

RESOURCE USAGE:
  CPU: < 2%    RAM: < 30 MB    GPU: None    Disk: < 2 MB
```

## Quick Start

```bash
# Clone
git clone https://github.com/Danielfoojunwei/UHCI-Net-Intel.git
cd UHCI-Net-Intel

# Install dependencies
pip install torch numpy

# Initialize model weights
python3 sac_ltc_agent.py --init-weights

# Self-test
python3 sac_ltc_agent.py --test

# Train the model (optional — pre-trained weights included after init)
python3 train_sac_ltc.py --episodes 2000
python3 train_sac_ltc.py --eval
```

## Usage as Claude Code Skill

Copy `SKILL.md` to your Claude Code skills directory and invoke with `/net-intel` or ask naturally:

- "Check my network"
- "Why is my WiFi slow?"
- "Is someone nearby?"
- "Where should I move for better signal?"
- "Start sentinel mode"
- "What's competing for my channel?"

## Modes

### Quick Scan
One-shot network diagnostics with scoring and recommendations.

### Monitor Mode
Autonomous background monitoring. Auto-switches networks, optimizes DNS, logs everything to `~/.net-intel/history.jsonl`.

### Sentinel Mode
Live spatial awareness — continuous RSSI monitoring for presence detection and environmental changes.

### Query Mode
Ask questions anytime — get data-backed answers from monitoring history.

## Training Pipeline

The SAC-LTC agent is trained on physics-grounded RF environments (not mocked):

- **ITU-R P.1238** — Indoor propagation with wall penetration
- **ITU-R P.838-3** — Rain attenuation
- **3GPP TR 38.901** — UMa NLOS path loss (7-24 GHz)
- **Shannon-Hartley** — Theoretical capacity from SNR
- **Thermal noise model** — kTB noise floor

Each episode simulates 5 networks (Wi-Fi APs + cellular hotspots) with realistic congestion patterns, interference events, and human movement.

```
Training Results:
  Parameters:     17,274
  Episodes:       1,000
  Training time:  ~9 minutes (CPU)
  Improvement:    36.2% over random baseline
```

## Why SAC-LTC Is Better Than Normal Tools

| Your OS built-in tools | This system |
|---|---|
| Signal bars or raw dBm | Score 0-100 with explanation |
| "Try resetting adapter" | "Ch149 has 5 competing networks, your SNR dropped 12dB due to adjacent-channel interference" |
| Snapshot only | LTC tracks 24h trends, predicts degradation |
| Manual switching | Autonomous optimization |
| No presence detection | Senses movement through walls via RSSI variance |
| No navigation | "Walk 2m right for +6dBm improvement" |

## Files

| File | Purpose |
|------|---------|
| `SKILL.md` | Claude Code skill — all modes, commands, output templates |
| `sac_ltc_agent.py` | Lightweight inference agent — LTC + KAN + sensing + explainability |
| `train_sac_ltc.py` | Training pipeline — ITU-R/3GPP physics, SAC with twin critics |
| `README.md` | This file |

## Privacy

- All processing is local — no data leaves your device
- Only passively receives public AP beacon signals
- Presence detection senses signal disruptions, not individuals
- History stored only in `~/.net-intel/`, user-controlled

## License

MIT

## Credits

Derived from [PreceptualAI UHCI](https://github.com/Danielfoojunwei/PreceptualAI-Universal-Heterogeneous-Connectivity-Intelligence-UHCI-) by Daniel Foo Jun Wei.
