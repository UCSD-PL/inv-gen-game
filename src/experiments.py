import socket
import subprocess
import os
import json

dirname = os.path.dirname
ROOT_DIR = dirname(dirname(os.path.abspath(os.path.realpath(__file__))))

def get_log_dir():
    return os.path.join(ROOT_DIR, 'logs')

def get_log_fname(name):
    return os.path.join(ROOT_DIR, 'logs', name)

def get_server_run_cmd():
    return os.path.join(ROOT_DIR, "src", "server.py")

def get_lvlset_dir(lvlset):
    return os.path.join(ROOT_DIR, lvlset)

class Session:
    def __init__(self, sess_id, hit_id, server_pid):
        self.sess_id = sess_id
        self.hit_id = hit_id
        self.server_pid = server_pid

class Experiment:
    def __init__(self, experiment_id):
        self.experiment_id = experiment_id
        self.fname = get_log_fname(str(experiment_id) + '.exp')
        self.sessions = self.read_sessions()
    def read_sessions(self):
        self.sessions = []
        try:
            with open(self.fname, "rb") as f:
                for line in f:
                    s = json.loads(line)
                    self.sessions.append(Session(s[0], s[1], s[2]))
                #Sessions.map = json.load(f)
                #Sessions.map = pickle.load(f)
        except IOError:
            # file does not exist, create it
            self.store_sessions()
        return self.sessions
    def store_sessions(self):
        with open(self.fname, 'wb') as f:
            for s in self.sessions:
                json.dump([s.sess_id, s.hit_id, s.server_pid], f)
                f.write("\n")
            #json.dump(Sessions.get_map(), f)
            #pickle.dump(Sessions.get_map(), f)
    def create_unique_session_id(self):
        res = 0
        for s in self.sessions:
            if s.sess_id > res:
                res = s.sess_id
        return res + 1
        # m = Sessions.get_map()
        # k = [int(x) for x in m.keys()]
        # k.sort()
        # return str(k[len(k)-1]+1)
    def add_session(self, s):
        self.sessions.append(s)
        self.store_sessions()
    # @staticmethod
    # def set(k,v):
    #     m = Sessions.get_map()
    #     m[str(k)] = v
    #     Sessions.store_map()

def create_new_experiment():
    experiment_id = 0
    for file_name in os.listdir(get_log_dir()):
        if file_name.endswith(".exp"):
            i = int(os.path.splitext(file_name)[0])
            if i > experiment_id:
                experiment_id = i
    return Experiment(experiment_id+1)

def get_unused_port():
    s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    s.bind(('localhost', 0))
    addr, port = s.getsockname()
    s.close()
    return port

def get_server_log_fname(experiment_id, session_id):
    return get_log_fname(str(experiment_id) + "." + str(session_id) + ".slog")

def get_event_log_fname(experiment_id, session_id):
    return get_log_fname(str(experiment_id) + "." + str(session_id) + ".elog")

def start_server(port, experiment_id, session_id):
    base_name = str(experiment_id) + "." + str(session_id)
    server_log = get_server_log_fname(experiment_id, session_id)
    event_log = get_event_log_fname(experiment_id, session_id)
    with open(server_log, 'w') as output:
        p = subprocess.Popen([get_server_run_cmd(), "--port", str(port), "--log", event_log], stdout=output, stderr=subprocess.STDOUT)
    return p
