const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');
const { insertUser, selectUserByEmailAddress, updateUser } = require('../services/users');
const { jwtSecret } = require('../config/jwt');

const createUser = async (req, res) => {
    const { email_address, password, first_name, last_name, address, phone_number } = req.body;
    const password_hash = await bcrypt.hash(password, await bcrypt.genSalt(10));

    const user = {
        email_address,
        password: password_hash,
        first_name,
        last_name,
        address,
        phone_number
    }

    insertUser(user, (err, results, fields) => {
        if (err) throw err;
        res.status(201).send('Success');
    });
}

const authenticateUser = async (req, res) => {
    const { email_address, password } = req.body;

    selectUserByEmailAddress(email_address, async (err, results, fields) => {
        if (err) throw err;
        if (!results.length) return res.status(404).send('E-mail address is not registered!');

        const user = results[0];

        const match = await bcrypt.compare(password, user.password);
        if (!match) return res.status(401).send('Incorrect password!');

        const token = jwt.sign({ user_id: user.user_id }, jwtSecret, { expiresIn: 86400 /* 24 hours */ });
        res.json({ token });
    });

}

const getProfile = (req, res) => {
    res.json({ ...req.user });
}

const updateProfile = async (req, res) => {
    const oldUser = req.user;
    const newUser = req.body;
    
    const user = {
        user_id: oldUser.user_id,
        email_address: newUser.email_address || oldUser.email_address,
        first_name: newUser.first_name || oldUser.first_name,
        last_name: newUser.last_name || oldUser.last_name,
        address: newUser.address || oldUser.address,
        phone_number: newUser.phone_number || oldUser.phone_number,
        password: newUser.password != null ? await bcrypt.hash(newUser.password, await bcrypt.genSalt(10)) : undefined
    }

    updateUser(user, (err, results, fields) => {
        if (err) throw err;

        const { email_address, first_name, last_name, address, phone_number } = user;
        res.json({ email_address, first_name, last_name, address, phone_number });
    });
}

module.exports = { createUser, authenticateUser, getProfile, updateProfile }