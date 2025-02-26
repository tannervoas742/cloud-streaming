Frame Rate Controls
===================

.. contents::

The Encoder service of Intel's Cloud Gaming software stack for Android (officially
"Intel Cloud Streaming System Software on Android" or "ICS3A") supports two modes
of operation with respect to frame-rate management. This document summarizes these
modes of operation in the sections below.

The Encoder service receives frames to encode from the Capture / Render component,
and submits them to the Hardware Media engine. For the ICS3A stack, Android
in Container (AiC) serves as the Render component. The two operating modes
differ in how these frames are handled, and they each come with a trade-off
related to bit-rate control. Users can choose the mode best suitable to their needs.


Encoding with Constant Frame Rate
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
In this mode, the Encoder delivers the specified target Encode frame rate no matter
what the input frame rate from the Capture / Render component is. This mode leverages
a timer that corresponds to the target Encode frame rate. Upon the timer elapsing,
the app submits the last frame available to the Hardware Media Engine.

This can result in dropped/repeated frames depending on how quick/late input
frames are made available to the Encoder service. For example, if the target
Encode rate is 30 fps,  Render frame rates of 60 fps and 15 fps will result in
frame drops and artificial frame repeats respectively.

When the Render frame rate is lower than the Encode frame rate, this mode produces
a constant frame rate, but it has a known quality problem. When the input content
has low-motion frames interspersed with high motion ones, the Bitrate Control module
doesn't handle such a case optimally. It can produce an unsteady bit rate pattern
with a very low bit count for the low-motion frames (in this case, completely static
due to repeat frames) and a high bit-count for the non-static ones. In a low-delay
scenario such as this, the low-size frames make poor reference frames for subsequent
frames.

This mode does not in any way prioritize minimizing the processing latency for a
single frame (from submission to Encoder till bitstream-output). By definition, the
priority is to generate a constant frame rate for downstream consumption. This is
the default mode of execution for the Encoder service app, and can be explicitly
specified by the option ``-renderfps_enc 0`` on the command line invocation::

  ./icr_encoder 0 -streaming -res 1280x720 -fr 30 -url irrv:264 -plugin qsv -lowpower -quality 4 -ratectrl VBR
  -b 3.3M -maxrate 3.6M -hwc_sock /opt/workdir/ipc/hwc-sock -renderfps_enc 0

Note that while this is the default setting for the ICR Encoder app, the ICS3A
deployment by default configures the Encoder to follow the Render frame rate i.e. the 
mode described below.


Encoding with Render Frame Rate
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

In this mode, the Encoder generally waits to receive a frame from the Capture / Render
component, and submits the frame to the Media Engine with minimal latency overhead. In this
mode, the frame rate generated by the Encoder is expected to correspond to whatever the
Render frame rate is. As the Encoder just follows the Render component (AiC for ICS3A),
the onus of maintaining a reasonable frame rate lies with the latter.

This mode has a known rate-control problem as well. The parameters of the rate control
operation including the expected (Encode) frame rate are configured during initialization
of the Encoder. Thus, the app still requires an input to be specified for the Encode
frame rate. If the actual Encode frame rate (that follows Render) doesn't match this,
the generated bitrate will be incorrect and can cause quality issues. 

For example, consider this scenario. The Encoder is initialized with frame rate specified
as 60 fps and target bitrate 10 Mbps. However, the Render component feeds the Encoder at
a very high 240 fps. In this scenario, the Encoder then follows Render to produce 240 fps
as well, and a bitrate closer to 40 Mbps instead of the target 10 Mbps. This can
potentially overwhelm the network capability, and can result in visual quality problems
with poor user experience. Encoding with Constant Frame Rate (described in previous
section) doesn't have this problem.

This mode is enabled by explicitly choosing the option ``-renderfps_enc 1`` on the Encoder
app command line along with the target encode frame rate. In the following example
we specify a 30 fps target frame rate::

  ./icr_encoder 0 -streaming -res 1280x720 -fr 30 -url irrv:264 -plugin qsv -lowpower -quality 4 -ratectrl VBR
  -b 3.3M -maxrate 3.6M -hwc_sock /opt/workdir/ipc/hwc-sock -renderfps_enc 1

Finally, this mode in its implementation supports a token minimum frame rate (default 3 fps),
to avoid client disconnections. This is configurable by the option ``minfps_enc``, and works 
using a mechanism similar to the Constant Encode frame rate mode. It is recommended to leave
this unchanged, as frame rates in practical usage don't bring this into play at all.
