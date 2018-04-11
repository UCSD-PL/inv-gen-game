define(["require", "exports", "./util", "esprima"], function (require, exports, util_1, esprima_1) {
    "use strict";
    Object.defineProperty(exports, "__esModule", { value: true });
    var notDefRe = /(.*) is not defined/;
    class InvException extends Error {
        constructor(name, message) {
            super(message);
            this.name = name;
            this.message = message;
        }
    }
    exports.InvException = InvException;
    class ImmediateErrorException extends InvException {
        constructor(name, message) {
            super(name, message);
            this.name = name;
            this.message = message;
        }
    }
    exports.ImmediateErrorException = ImmediateErrorException;
    function interpretError(err) {
        if (err.name === "ReferenceError") {
            if (err.message.match(notDefRe))
                return err.message.match(notDefRe)[1] + " is not defined.";
            else
                return "Not a valid expression.";
        }
        else if (err.name == 'SyntaxError') {
            return "Not a valid expression.";
        }
        else if (err.name == 'NOT_BOOL') {
            return "Expression should evaluate to true or false, not " + err.message + " for example.";
        }
        else if (err.name == "UnsupportedError"
            || err.name == "IMPLICATION_TYPES"
            || err.name == "OPERATOR_TYPES") {
            return err.message;
        }
        return err;
    }
    exports.interpretError = interpretError;
    function invToJS(inv) {
        return inv.replace(/[^<>]=[^>]/g, function (v) { return v[0] + "==" + v[2]; })
            .replace(/=>/g, "->")
            .replace(/(.+)if(.+)/g, "($2) -> ($1)");
        //.replace(/if(.+)then(.+)/g, "($1) -> ($2)")
    }
    exports.invToJS = invToJS;
    function holds(inv, variables, data) {
        let res = invEval(inv, variables, data);
        return evalResultBool(res) &&
            res.filter((x) => !(x === true)).length == 0;
    }
    function check_implication(arg1, arg2) {
        if (typeof (arg1) != "boolean" || typeof (arg2) != "boolean") {
            throw new InvException("IMPLICATION_TYPES", "Implication expects 2 booleans, not " + arg1 + " and " + arg2);
        }
        return (!arg1 || arg2);
    }
    function check_boolean(arg, op) {
        if (typeof (arg) !== "boolean") {
            throw new InvException("OPERATOR_TYPES", op + " expects a boolean, not " +
                arg);
        }
        return true;
    }
    function check_number(arg, op) {
        if (typeof (arg) !== "number") {
            throw new InvException("OPERATOR_TYPES", op + " expects a number, not " +
                arg);
        }
        return true;
    }
    function both_booleans(arg1, arg2, op) {
        if (typeof (arg1) !== "boolean" || typeof (arg2) !== "boolean") {
            throw new InvException("OPERATOR_TYPES", op + " expects 2 booleans, not " +
                arg1 + " and " + arg2);
        }
        return true;
    }
    function both_numbers(arg1, arg2, op) {
        if (typeof (arg1) !== "number" || typeof (arg2) !== "number") {
            throw new InvException("OPERATOR_TYPES", op + " expects 2 numbers, not " +
                arg1 + " and " + arg2);
        }
        return true;
    }
    function same_type(arg1, arg2, op) {
        if (typeof (arg1) !== typeof (arg2)) {
            throw new InvException("OPERATOR_TYPES", op + " expects operands of the" +
                " same type, not " + arg1 + " and " + arg2);
        }
        return true;
    }
    function invEval(inv, variables, data) {
        // Sort variable names in order of decreasing length
        let vars = variables.map(function (val, ind, _) { return [val, ind]; });
        let holds_arr = [];
        // Do substitutions and eval
        for (var row in data) {
            let valMap = vars.reduce((m, el) => { m[el[0]] = data[row][el[1]]; return m; }, {});
            let instantiatedInv = instantiateVars(inv, valMap);
            holds_arr.push(eval(esprimaToEvalStr(instantiatedInv)));
        }
        return holds_arr;
    }
    exports.invEval = invEval;
    function evalResultBool(evalResult) {
        for (let i in evalResult) {
            if (evalResult[i] instanceof Array)
                return evalResultBool(evalResult[i]);
            if (typeof (evalResult[i]) !== "boolean")
                return false;
        }
        return true;
    }
    exports.evalResultBool = evalResultBool;
    function estree_reduce(t, cb) {
        if (t.type === "Program") {
            let p = t;
            let es = p.body[0];
            return cb(t, [estree_reduce(es.expression, cb)]);
        }
        if (t.type === "BinaryExpression") {
            let be = t;
            let lhs = estree_reduce(be.left, cb);
            let rhs = estree_reduce(be.right, cb);
            return cb(t, [lhs, rhs]);
        }
        if (t.type === "LogicalExpression") {
            let be = t;
            let lhs = estree_reduce(be.left, cb);
            let rhs = estree_reduce(be.right, cb);
            return cb(t, [lhs, rhs]);
        }
        if (t.type === "UnaryExpression") {
            let ue = t;
            let exp = estree_reduce(ue.argument, cb);
            return cb(t, [exp]);
        }
        if (t.type === "Literal") {
            return cb(t, []);
        }
        if (t.type === "Identifier") {
            return cb(t, []);
        }
        util_1.assert(false, "Shouldn't get here");
    }
    function identifiers(inv) {
        if (typeof (inv) === "string")
            return identifiers(esprima_1.parse(inv));
        let t = inv;
        return estree_reduce(t, (nd, args) => {
            if (nd.type === "Program")
                return args[0];
            if (nd.type === "BinaryExpression" || nd.type === "LogicalExpression") {
                return util_1.union(args[0], args[1]);
            }
            if (nd.type === "UnaryExpression") {
                return args[0];
            }
            if (nd.type === "Identifier") {
                let r = util_1.emptyStrset();
                r.add(nd.name);
                return r;
            }
            return util_1.emptyStrset();
        });
    }
    exports.identifiers = identifiers;
    function literals(inv) {
        if (typeof (inv) === "string")
            return literals(esprima_1.parse(inv));
        return estree_reduce(inv, (nd, args) => {
            if (nd.type === "Program")
                return args[0];
            if (nd.type === "BinaryExpression" || nd.type === "LogicalExpression") {
                return util_1.union(args[0], args[1]);
            }
            if (nd.type === "UnaryExpression") {
                return args[0];
            }
            if (nd.type === "Literal") {
                let r = util_1.emptyStrset();
                r.add(nd.value);
                return r;
            }
            return util_1.emptyStrset();
        });
    }
    exports.literals = literals;
    function operators(inv) {
        if (typeof (inv) === "string")
            return operators(esprima_1.parse(inv));
        return estree_reduce(inv, (nd, args) => {
            if (nd.type === "Program")
                return args[0];
            if (nd.type === "BinaryExpression" || nd.type === "LogicalExpression") {
                let be = nd;
                let p = util_1.emptyStrset();
                p.add(be.operator);
                return util_1.union(util_1.union(p, args[0]), args[1]);
            }
            if (nd.type === "UnaryExpression") {
                let ue = nd;
                let p = util_1.emptyStrset();
                p.add(ue.operator);
                return util_1.union(p, args[0]);
            }
            return util_1.emptyStrset();
        });
    }
    exports.operators = operators;
    function replace(inv, replF) {
        if (typeof (inv) === "string")
            return replace(esprima_1.parse(inv), replF);
        return estree_reduce(inv, (nd, args) => {
            if (nd.type === "Program") {
                let p = nd;
                let es = p.body[0];
                return {
                    "type": "Program",
                    "body": [{
                            "type": "ExpressionStatement",
                            "expression": replace(es.expression, replF)
                        }],
                    "sourceType": "script"
                };
            }
            if (nd.type === "BinaryExpression") {
                let be = nd;
                return replF({ "type": "BinaryExpression",
                    "operator": be.operator,
                    "left": args[0],
                    "right": args[1],
                });
            }
            if (nd.type === "LogicalExpression") {
                let le = nd;
                return replF({
                    "type": "LogicalExpression",
                    "operator": le.operator,
                    "left": args[0],
                    "right": args[1],
                });
            }
            if (nd.type === "UnaryExpression") {
                let ue = nd;
                return replF({
                    "type": "UnaryExpression",
                    "operator": ue.operator,
                    "argument": args[0],
                });
            }
            if (nd.type === "Literal" || nd.type === "Identifier") {
                return replF(nd);
            }
        });
    }
    function instantiateVars(inv, vals) {
        return replace(inv, (node) => {
            if (node.type == "Identifier") {
                let val = vals[node.name];
                return { type: "Literal", raw: "" + val, value: val };
            }
            return node;
        });
    }
    function generalizeConsts(inv) {
        let symConsts = [];
        let newInv = replace(inv, (node) => {
            if (node.type == "Literal") {
                var newId = "a" + symConsts.length;
                symConsts.push(newId);
                return { "type": "Identifier", "name": newId };
            }
            return node;
        });
        return [newInv, symConsts, []];
    }
    function generalizeInv(inv) {
        let symConsts = [];
        let symVars = [];
        let newInv = replace(inv, (node) => {
            if (node.type == "Literal") {
                var newId = "a" + symConsts.length;
                symConsts.push(newId);
                return { "type": "Identifier", "name": newId };
            }
            if (node.type == "Identifier") {
                var newId = "x" + symVars.length;
                symVars.push(newId);
                return { "type": "Identifier", "name": newId };
            }
            return node;
        });
        return [newInv, symConsts, symVars];
    }
    exports.generalizeInv = generalizeInv;
    function fixVariableCase(inv, vars) {
        var stringM = {};
        for (let v of vars)
            stringM[v.toLowerCase()] = v;
        return replace(inv, (node) => {
            if (node.type == "Identifier" && node.name.toLowerCase() in stringM) {
                return { "type": "Identifier", "name": stringM[node.name.toLowerCase()] };
            }
            else {
                return node;
            }
        });
    }
    exports.fixVariableCase = fixVariableCase;
    function esprimaToStr(nd) {
        return estree_reduce(nd, (nd, args) => {
            if (nd.type == "Program") {
                return args[0];
            }
            if (nd.type == "BinaryExpression") {
                let be = nd;
                return "(" + args[0] + be.operator + args[1] + ")";
            }
            if (nd.type == "LogicalExpression") {
                let le = nd;
                return "(" + args[0] + le.operator + args[1] + ")";
            }
            if (nd.type == "UnaryExpression") {
                let ue = nd;
                let s = args[0];
                if (ue.operator == '-' && s[0] == '-')
                    s = '(' + s + ')';
                return "(" + ue.operator + s + ")";
            }
            if (nd.type == "Literal") {
                return "" + nd.value;
            }
            if (nd.type == "Identifier") {
                return nd.name;
            }
        });
    }
    exports.esprimaToStr = esprimaToStr;
    let NUM_BINOPS = new Set(["+", "-", "*", "/", "%", "<", ">", "<=", ">="]);
    function esprimaToEvalStr(nd) {
        return estree_reduce(nd, (nd, args) => {
            if (nd.type == "Program") {
                return args[0];
            }
            if (nd.type == "BinaryExpression") {
                let be = nd;
                var checker;
                if (NUM_BINOPS.has(be.operator))
                    checker = "both_numbers";
                else
                    checker = "same_type";
                return "(" + checker + "(" + args[0] + "," + args[1] + ",\"" +
                    be.operator + "\")&&(" + args[0] + be.operator + args[1] + "))";
            }
            if (nd.type == "LogicalExpression") {
                let le = nd;
                if (le.operator == "->")
                    return "check_implication(" + args[0] + "," + args[1] + ")";
                else
                    return "(both_booleans(" + args[0] + "," + args[1] + ",\"" +
                        le.operator + "\")&&(" + args[0] + le.operator + args[1] + "))";
            }
            if (nd.type == "UnaryExpression") {
                let ue = nd;
                if (ue.operator == "!")
                    checker = "check_boolean";
                else
                    checker = "check_number";
                return "(" + checker + "(" + args[0] + ",\"" + ue.operator + "\")&&(" +
                    ue.operator + "(" + args[0] + ")))";
            }
            if (nd.type == "Literal") {
                return "(" + nd.value + ")";
            }
            if (nd.type == "Identifier") {
                return nd.name;
            }
        });
    }
});
//# sourceMappingURL=eval.js.map