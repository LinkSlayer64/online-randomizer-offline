from __future__ import unicode_literals
import time

import json

from flask import Flask
from flask import render_template, jsonify, request
app = Flask(__name__)
app.config['APPLICATION_ROOT'] = '/randomizer'

import randomizer

games_json = {}
for game in randomizer.games:
    game_json = {}
    game_json['name'] = game.name
    game_json['options'] = {}#game.options
    games_json[game.identifier] = game_json

games_json = json.dumps(games_json)
    
cooldowns = {}

@app.route('/generate', methods=["POST"])
def generate():
    ip = request.remote_addr
    if ip in cooldowns and time.time() < cooldowns[ip] + 60:
        return jsonify({'cooldown': (cooldowns[ip] + 60) - time.time()})
    starttime = time.time()
    gameid = request.form.get('game')
    for g in randomizer.games:
        #print g.identifier, gameid
        if g.identifier == gameid:
            Game = g
    
    game = Game()
    form = game.Form(request.form)
    for field in form:
        game.choices[field.name] = field.data
    filename = game.produce(filename=request.form.get('filename'))
    
    endtime = time.time()
    cooldowns[ip] = endtime
    
    timedelta = time.time() - starttime
    return jsonify({'filename': filename, 'time': timedelta})
    

@app.route("/")
def index():
    return render_template("index.html", games=randomizer.games, games_json=games_json)

if __name__ == "__main__":
    print "Running..."
    app.run(host="", port=8080, debug=True, threaded=True)

if not app.debug:
    import logging
    file_handler = logging.FileHandler('flask.log')
    file_handler.setLevel(logging.WARNING)
    app.logger.addHandler(file_handler)
