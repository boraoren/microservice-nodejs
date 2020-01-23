import {Request, Response, Router} from 'express';

import {User} from '../models/User';

const router: Router = Router();

router.get('/', async (req: Request, res: Response) => {
    res.send('This is auth root endpoint');
});

router.get('/:id', async (req: Request, res: Response) => {
    const { id } = req.params;
    const item = await User.findByPk(id);
    res.send(item);
});

export const UserRouter: Router = router;
