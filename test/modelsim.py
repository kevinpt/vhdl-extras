from __future__ import print_function, division

import os
import time
import subprocess as subp
import threading
from threading import Thread
import Queue as queue
import scripts.color as color


def enqueue_pipe(pipe, queue):
  try:
    for ln in iter(pipe.readline, b''):
      queue.put(ln)
  except:
    pass

  pipe.close()


def get_output(outq):
  out = ''
  try:
    while True: # Add output from the queue until it is empty
      out += outq.get_nowait()
  except queue.Empty:
    return out


class Modelsim(object):
  def __init__(self, log_file='vsim.log'):
    self.log_file = log_file
    self.p = None
    self.outq = None
    self.errq = None

    self._setup_vsim_process()

  def _setup_vsim_process(self):
    print('\n' + color.success('*** Starting Modelsim ***'))
    env = { 'MGC_WD': os.getcwd(), 'PATH': os.environ['PATH'] }
    self.p = subp.Popen(['vsim',  '-c', '-l', self.log_file], env=env, stdin=subp.PIPE, stderr=subp.PIPE, stdout=subp.PIPE)

    self.outq = queue.Queue()
    self.errq = queue.Queue()

    out_thread = Thread(target=enqueue_pipe, args=(self.p.stdout, self.outq))
    err_thread = Thread(target=enqueue_pipe, args=(self.p.stderr, self.errq))
    out_thread.daemon = True
    err_thread.daemon = True
    out_thread.start()
    err_thread.start()

    # Keep the process from dying on an elaboration error
    self.p.stdin.write('onElabError resume\n')

    # Define a dummy sentinel proc
    self.p.stdin.write('proc sentinel {} {}\n')
    self.p.stdin.flush()

    # Wait for Modelsim to start and process our commands
    while True:
      out = get_output(self.outq)
      if 'sentinel' in out: break


  def restart(self):
    del self.outq
    del self.errq
    self._setup_vsim_process()


  def exec_tcl(self, cmd, verbose=False):
    '''Execute a TCL command in the Modelsim interpreter.

    We want to execute a command and wait until it is complete
    before proceeding. This can be done by waiting for the prompt
    to appear but a complication arises because we use blocking I/O
    (readline) to fill the queues. Python doesn't provide platform
    independent non-blocking I/O so we cannot see when an incomplete
    line with a prompt is output.

    As a hack we call the dummy "sentinel" command after every
    requested command. This ceates a complete line with a signature
    we can look for. When sentinel shows up in the output stream we
    know that the previous command finished.
    '''

    #print('### PID:', self.p.pid)

    self.p.stdin.write(cmd + '\n')
    self.p.stdin.write('sentinel\n')
    self.p.stdin.flush()

    out = []
    while True:
      if self.process_done(): break  # The process died

      out.append(get_output(self.outq))
      if '> sentinel' in out[-1]: break # Stop when we see the prompt with the sentinel

    result = '\n'.join(''.join(out).split('\n')[:-2])
    if verbose: print(result)
    return result

  def process_done(self):
    return self.p.poll() is not None


  def quit(self):
    print('\n\n' + color.note('*** Stopping Modelsim ***'))
    err = get_output(self.errq);
    #print('### Threads:', threading.enumerate())
    self.p.stdin.write('quit\n')
    self.p.kill()
    self.p = None

    if len(err) > 0:
      print('#### Errors:\n', err)

    # Strip sentinel commands from the log
    with open(self.log_file, 'r') as fh:
      fh.readline() # Toss out first line with sentinel proc definition
      clean_log = [ln for ln in fh if not ln.startswith('sentinel')]

    with open(self.log_file, 'w') as fh:
      fh.writelines(clean_log)

  def __del__(self):
    if self.p is not None:
      self.quit()


