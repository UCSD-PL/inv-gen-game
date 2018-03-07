class BaseContainer {
    constructor(parent) {
        this.parent = parent;
        this.clear();
    }
    add(key, obj, representation) {
        if (this.objMap.hasOwnProperty(key)) { }
        ; //TODO: What do we do?
        this.objMap[key] = obj;
        this.domMap[key] = this.addElement(key, obj, representation);
    }
    ;
    remove(key) {
        if (!this.objMap.hasOwnProperty(key)) {
            throw new Error("Key " + key + " not found.");
        }
        this.removeElement(key, this.objMap[key], this.domMap[key]);
        delete this.objMap[key];
        delete this.domMap[key];
    }
    ;
    forEach(cb) {
        for (var key in this.objMap) {
            cb(key, this.objMap[key], this.domMap[key]);
        }
    }
    contains(key) {
        return this.objMap.hasOwnProperty(key);
    }
    clear() {
        this.initEmpty();
        this.objMap = {};
        this.domMap = {};
    }
    set(vals) {
        this.clear();
        for (var i in vals) {
            this.add(vals[i][0], vals[i][1], vals[i][2]);
        }
    }
}
//# sourceMappingURL=container.js.map