const { selectChildren, selectChildById, selectChildParentById, insertChild, deleteChildById, updateChildById } = require('../services/children');
const { selectParentChildrenById } = require('../services/parents');
const bcrypt = require('bcrypt');
const { selectUserByEmailAddress } = require('../services/users');

const getChildren = async (req, res) => {
    try {
        const [children] = await selectChildren();
        res.json(children);
    } catch (err) {
        console.warn(`Generic: ${err}`);
        res.status(500).send('Internal Server Error');
    };
};

const getMyChildren = async (req, res) => {
    const parent_id = req.user.user_id;

    try {
        const [children] = await selectParentChildrenById(parent_id);
        res.json(children);
    } catch (err) {
        console.warn(`Generic: ${err}`);
        res.status(500).send('Internal Server Error');
    };
};

const getChildById = async (req, res) => {
    const { child_id } = req.params;

    try {
        const [children] = await selectChildById(child_id);
        if (!children.length) return res.status(404).send('Child Not Found');

        res.json(children[0]);
    } catch (err) {
        console.warn(`Generic: ${err}`);
        res.status(500).send('Internal Server Error');
    };
};

const getChildParentById = async (req, res) => {
    const { child_id } = req.params;

    try {
        const [parents] = await selectChildParentById(child_id);
        if (!parents.length) return res.status(404).send('Parent Not Found');

        res.json(parents[0]);
    } catch (err) {
        console.warn(`Generic: ${err}`);
        res.status(500).send('Internal Server Error');
    };
};

const createChild = async (req, res) => {
    const { email_address, first_name, last_name, address, phone_number } = req.body;
    const password = await bcrypt.hash(req.body.password, await bcrypt.genSalt(10));
    const parent_id = req.user.user_id;

    const child = {
        email_address,
        password,
        first_name,
        last_name,
        address,
        phone_number,
        parent_id
    };

    try {
        await insertChild(child);

        const [users] = await selectUserByEmailAddress(email_address);
        res.status(201).json({ ...users[0], password: undefined, role: undefined });
    } catch (err) {
        console.warn(`Generic: ${err}`);
        res.status(500).send('Internal Server Error');
    };
};

const deleteChild = async (req, res) => {
    const { child_id } = req.params;

    try {
        await deleteChildById(child_id);
        res.status(200).send('Success');
    } catch (err) {
        console.warn(`Generic: ${err}`);
        res.status(500).send('Internal Server Error');
    };
};

const updateChild = async (req, res) => {
    const { child_id } = req.params;
   
    const [children] = await selectChildById(child_id);
    const oldChild = children[0];
    const newChild = req.body;

    const child = {
        email_address: oldChild.email_address,
        first_name: newChild.first_name || oldChild.first_name,
        last_name: newChild.last_name || oldChild.last_name,
        address: newChild.address || oldChild.address,
        phone_number: newChild.phone_number || oldChild.phone_number,
        password: newChild.password != null ? await bcrypt.hash(newChild.password, await bcrypt.genSalt(10)) : undefined
    };

    try {
        await updateChildById(child_id, child);

        const { email_address, first_name, last_name, address, phone_number } = child;
        res.json({ email_address, first_name, last_name, address, phone_number });
    } catch (err) {
        console.warn(`Generic: ${err}`);
        res.status(500).send('Internal Server Error');
    };
};

module.exports = { getChildren, getChildById, getChildParentById, createChild, getMyChildren, deleteChild, updateChild };