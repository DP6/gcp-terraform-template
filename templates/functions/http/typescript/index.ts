import Express from 'express';

export function main(req: Express.Request, res: Express.Response): void {
  
  res.status(200).send("ok");
}